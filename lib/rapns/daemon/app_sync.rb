module Rapns
  module Daemon
    class AppSync
      include InterruptibleSleep

      class << self
        attr_accessor :app_sync
      end

      @app_sync = nil

      def self.start
        app_sync = AppSync.new
        app_sync.start
      end

      def self.stop
        app_sync.stop if app_sync
      end

      def start
        Rapns::Daemon.logger.info("Started app sync.")
        @thread = Thread.new do
          loop do
            sync_apps
            interruptible_sleep(Rapns.config.app_sync_interval)
            break if @stop
          end
        end
      end

      def stop
        @stop = true
        interrupt_sleep
        @thread.join if @thread
      end

      def sync_apps
        Rapns::Daemon.logger.info("Syncing apps")
        Rapns::Daemon::AppRunner.sync
      end
    end
  end
end