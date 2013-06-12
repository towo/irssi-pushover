irssi-pushover
==============

This is a simple irssi plugin to forward mentions you receive in your
[irssi](http://irssi.org) IRC client to the [Pushover](http://pushover.net)
service.

Prerequisites
-------------
* irssi (duh)
* LWP::UserAgent
* Net::HTTPS or Crypt::SSLeay
* IO::Socket::SSL

Settings
--------
It will export new options to your irssi configuration:

* `pushover_enable`: Does what it says, enables the pushover integration.
* `pushover_api_token`: The API token of the application. By default, towo's API key is supplied, but this may be subject to change depending on whatever Pushover's doing.
* `pushover_target_user`: The user token of the Pushover user who's supposed to get the messages. It's given on [your Pushover dashboard](http://pushover.net).
* `pushover_target_device`: The device name on the target Pushover account that's supposed to get the message. Specify a single device name or leave blank to send to all.
* `pushover_away_only`: Only send messages via Pushover if the user is currently away (on the server the message was received).

New users will have to define the `pushover_target_user` and then toggle `pushover_enable`. Everything _should_ go fine after that, and you should receive spammy messages on your phone rather rapidly. If you're popular, that is.

Licensing
---------
No worries, simple GPL3, i.e.:
>   This program is free software: you can redistribute it and/or modify
>   it under the terms of the GNU General Public License as published by
>   the Free Software Foundation, either version 3 of the License, or
>   (at your option) any later version.
>
>   This program is distributed in the hope that it will be useful,
>   but WITHOUT ANY WARRANTY; without even the implied warranty of
>   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>   GNU General Public License for more details.
>
>   You should have received a copy of the GNU General Public License
>   along with this program.  If not, see <http://www.gnu.org/licenses/>.
