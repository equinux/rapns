module Rapns
  module Daemon
    class AppSync
      include InterruptibleSleep

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
        Rapns::Daemon.logger.info("Stopped app sync.")
      end

      def sync_apps
        Rapns::Daemon.logger.info("Syncing apps")
        Rapns::Daemon::AppRunner.sync
      end
    end
  end
end