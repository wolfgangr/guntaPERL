# systemd setup machine

## old times vs new times

On development, I drafted the watchdog with 'good old' unix style in mind.
So my plan was to wirte sysV init scripts in the end.

However, the times of sysV init are gone without doubt, even if 10 yr old pro/con discussions still lingering on the web may tell sth else.
sytemd is PID0 in these days.

So I decided to climb the systemd learning curve and found it not too steep at all.

When the stuff in this dir is working in the end, the "old" cron based watchdog may go away.

## the plan:

* have a systemd compatible startup script spawning both the worker and the watchdog
* configure it for a watchdog at decent times
* configure a proper service descrition
* have a simple install script running
* the watchdog may still be used, but stripped down heavily
