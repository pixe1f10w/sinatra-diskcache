module Sinatra
    module DiskCache
        module Helpers
            def diskcache filename, &block
                unless settings.diskcache_enabled
                    if block_given?
                        block.call path_to filename
                        return resulting_name filename
                    end
                end

                file = cache_get filename

                if file
                    cache_log "get: #{filename}"
                    return resulting_name File.basename file.path
                elsif block_given?
                    cache_log "block invoked for #{filename}"
                    block.call path_to filename# if block_given?
                    return resulting_name filename
                end
            rescue => e
                throw e if settings.development? or settings.show_exceptions
                
                if block_given?
                    block.call path_to filename
                    return resulting_name filename
                end
            end

            private
            def cache_log msg
                puts "[sinatra-diskcache] #{msg}" if settings.diskcache_logging
            end

            private
            def path_to filename
                File.join settings.diskcache_path, filename
            end

            def resulting_name filename
                return settings.diskcache_full_paths == true ? path_to( filename ) : filename
            end

            def cache_get filename
                filepath = path_to filename

                if not File.size? filename
                    cache_log "#{filename} is empty, wiping"
                    File.delete filepath
                    nil
                else
#                if File.exist? filepath
#                    if not File.size? filename
#                        cache_log "#{filename} is empty, wiping"
#                        File.delete filepath
#                        return nil
#                    end

                    if ( File.ctime( filepath ) + settings.diskcache_expiry_period > Time.now ) or not settings.diskcache_expiry_enabled
                        begin
                            cache_log "found unexpirable file #{filepath}"
                            return File.new filepath, 'r'
                        rescue IOError => e
                            cache_log "can't open #{filename}, skipping"
                        end
                    else
                        cache_log "#{filename} expired, wiping"
                        File.delete filepath
                        nil
                    end
                end
            end
        end
        
        def self.registered app
            app.helpers DiskCache::Helpers

            # defaults
            app.set :diskcache_enabled, true
            app.set :diskcache_logging, true if app.development?
            app.set :diskcache_expiry_enabled, true
            app.set :diskcache_expiry_period, 3600
            app.set :diskcache_full_paths, true
            app.set :diskcache_path, "./diskcache"

            begin
                Dir.mkdir app.settings.diskcache_path unless File.exist? app.settings.diskcache_path
            rescue SystemCallError => e
                cache_log 'cant create cache dir, disabling cache'
                app.set :diskcache_enabled, false
            end
        end
    end

    register DiskCache
end
