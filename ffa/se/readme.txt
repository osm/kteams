"KT220ffa special edition" :-)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is just plain vanilla KT220ffa qwprogs.dat with two small fixes:

1. Fixed the bug in KT 2.20 (and 2.10) that made the server send
"serverinfo teamplay 0" to clients each frame.  That was causing two problems:

(1) Clients drop with a message "unnamed overflowed" upon connecting unless
they set their rate low, and

(2) It's difficult to play on a normal KT220ffa server from modem because
the network traffic is almost 1.5 times higher than in plain QW server!

2. The "say -d" bot check is now disabled by default due to QW source being
released (kleenex use unlikely). You can turn the check on if you want though,
by adding "localinfo k_botcheck 1" to your server.cfg

- Tonik, 03.01.2001
