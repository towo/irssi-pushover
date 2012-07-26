#!/usr/bin/perl
# irssi-pushover-notifier by Tobias 'towo' Wolter <irssi@towo.eu>
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

use Irssi;
use LWP::UserAgent;
use strict;
use warnings;
use vars qw($VERSION %IRSSI);

$VERSION = "20120725-1";
%IRSSI = (
	authors     => 'Tobias \'towo\' Wolter',
	contact     => 'irssi@towo.eu',
	name        => 'irssi-pushover-notifier',
	description => 'Sends irssi mentions and messages via Pushover',
	license     => 'GPLv3',
	url         => 'http://github.com/towo/irssi-pushover-notifier',
);


my $api = new LWP::UserAgent;
my $apiurl = 'https://api.pushover.net/1/messages.json';
my $response;

# some niceties
$api->agent("irssi-pushover-notifier/$VERSION");
$api->env_proxy;
$api->timeout(5); # too long timeouts would foul up IRC experience

# create a title for the pushover message
sub create_title {
	my ($type, $target) = @_;
	if ($type eq 'private') {
		return "irssi: private message from $target";
	} elsif ($type eq 'public') {
		return "irssi: public hilight in $target";
	} else {
		die "Received unknown message type \"$type\" in create_title\n";
	}
}

# check if api token and target user are set to something
sub sanity_check {
	if (Irssi::settings_get_str('pushover_api_token') =~ m/^\s*$/) {
		Irssi::print("pushover_api_token has not been set, disabling pushover.");
		Irssi::settings_set_bool('pushover_api_token', 0);
		return 0;
	} elsif (Irssi::settings_get_str('pushover_target_user') =~ m/^\s*$/) {
		Irssi::print("pushover_target_user has not been set, disabling pushover.");
		Irssi::settings_set_bool('pushover_target_user', 0);
		return 0;
	} else {
		return 1;
	}
}

# send the request to pushover
sub send_to_pushover {
	my ($type, $target, $message) = @_;
	my %request = (
		'token' => Irssi::settings_get_str('pushover_api_token'),
		'user' => Irssi::settings_get_str('pushover_target_user'),
		'title' => &create_title($type, $target),
		'message' => $message,
	);

	$response = $api->post( $apiurl, \%request );
	if ($response->is_error()) {
		# FIXME: this is lazy
		Irssi::print("Pushover returned an error while sending, please correct"
		           . " the mistake by analyzing this statement sent by the pushover API:\n"
		           . $response->decoded_content
		           . "\nDisabling pushover notifications.");
		Irssi::settings_set_bool('pushover_enable', 0);
	}
}

# handles the processing of messages
sub event_handler {
	my ($server, $msg, $nick, $address, $target) = @_;
	if (Irssi::settings_get_bool('pushover_enable')) {
		if (&sanity_check) {
			if ($target) {
				# public message
				send_to_pushover('public', $target, "<$nick> $msg") if ($msg =~ m/$server->{'nick'}/);
			} else {
				# private message
				send_to_pushover('private', $nick, $msg);
			}
		}
	}
}

# signal handlers
Irssi::signal_add("message public", "event_handler");
Irssi::signal_add("message private", "event_handler");

# relevant settings; self-explanatory; FIXME: categories
Irssi::settings_add_bool('misc', 'pushover_enable', 0);
Irssi::settings_add_str('misc', 'pushover_api_token', 'iV2kqvQaDnUEOK4UIIT9HtXnL0RtGL');
Irssi::settings_add_str('misc', 'pushover_target_user', '');

# TODO: possibly define device targets
# TODO: possibly define which levels should be forwarded to pushover
# TODO: toggle to only send hilights when away
