#!/usr/bin/perl

use strict;
use warnings;

use 5.10.0;

use DateTime;
use File::Copy qw(move);
use FindBin;
use Path::Class;

my %dot_files = (
    'agignore'    => '.agignore',
    'config.fish' => '.config/fish/config.fish',
    'gitconfig'   => '.gitconfig',
    'vimrc'       => '.vimrc',
);

my $source_dir = $FindBin::Bin . '/configuration/';
my $target_dir = $ENV{'HOME'} . '/';
my $timestamp = DateTime->now->datetime;

for my $dot_file (keys %dot_files) {
    my $from = $source_dir . $dot_file;
    my $to = $target_dir . $dot_files{$dot_file};
    my $bak = "$to-$timestamp.bak";

    move($to, $bak) if (-e $to);
    symlink($from, $to);
}

__END__

=head1 NAME

sync.pl - A small dotfiles sync script

=head1 SYNOPSIS

    $ ./sync.pl

=head1 DESCRIPTION

The script will safely symlink the files from the Git repo to the correct locations in the home folder.
If any of these files already exist, they will first be backed up by moving the file, appending the current timestamp.
After changing any config files, it is now trivial to commit/push these, and pull them on other machines.

Change the C<%dot_files> hash to add new configuration files to be synced.
The key corresponds to the repo file in the L</configuration> folder.
The value corresponds to the location on disk, with starting point C<$ENV{"HOME"}>.

=head1 LICENSE

This is released under GNU GENERAL PUBLIC LICENSE version 3.
See L<LICENSE>.

=head1 AUTHOR

Bram Inniger - L<http://inniger.be/>

=cut