package Bot::MetaSyntactic;
use strict;
use Acme::MetaSyntactic;
use Bot::BasicBot;

{ no strict;
  $VERSION = '0.01';
  @ISA = qw(Bot::BasicBot);
}

=head1 NAME

Bot::MetaSyntactic - IRC frontend to Acme::MetaSyntactic

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

    use Bot::MetaSyntactic;

    Bot::MetaSyntactic->new(
        nick => 'meta',
        name => 'Acme::MetaSyntactic IRC frontend',
        server => 'irc.perl.org',
        channels => ['#randomchan']
    )->run

=head1 DESCRIPTION

This module provides the glue for providing an IRC interface to 
the module C<Acme::MetaSyntactic>.

=head1 FUNCTIONS

=over 4

=item said()

Main function for interacting with the bot object. 
It follows the C<Bot::BasicBot> API and expect an hashref as argument. 
See L<"COMMANDS"> for more information on recognized commands. 

=cut

sub said {
    my $self = shift;
    my $args = shift;
    my($number,$theme);

    # don't do anything unless directly addressed
    return undef unless $args->{address} eq $self->nick or $args->{channel} eq 'msg';

    my @themes = Acme::MetaSyntactic->themes;

    {
      $args->{body} =~ s/(\d+)//;
      $number = $1 || 1;
    }

    {
      $args->{body} =~ s/(\w+)//;
      $theme = $1 || $Acme::MetaSyntactic::Theme;
    }

    if($theme eq 'themes') {
        $args->{body} = "Available themes: @themes";
        $self->say($args);
        return undef;
    }
    
    unless(exists $Acme::MetaSyntactic::META{$theme}) {
        $args->{body} = "No such theme: $theme";
        $self->say($args);
        return undef;
    }

    my $meta = Acme::MetaSyntactic->new($theme);
    $args->{body} = join ' ', $meta->name($number);
    $self->say($args);

    return undef
}

=item help()

Prints usage.

=cut

sub help {
    return "usage: meta [theme] [number]\n".
           "  use theme name 'themes' to print all available themes"
}

=back

=head1 COMMANDS

Syntax (assuming the name of the bot is C<meta>): 

    meta [theme] [number]
    meta themes

Called with no argument, print this number of random words from a random theme.

Called with a theme name, print this number of random words from this theme.

Called with C<themes>, print all available themes. 

=head1 AUTHOR

SE<eacute>bastien Aperghis-Tramoni, C<< <sebastien@aperghis.net> >>

=head1 BUGS

Please report any bugs or feature requests to
L<bug-bot-metasyntactic@rt.cpan.org>, or through the web interface at
L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=Bot-MetaSyntactic>. 
I will be notified, and then you'll automatically be notified 
of progress on your bug as I make changes.

=head1 COPYRIGHT & LICENSE

Copyright 2005 SE<eacute>bastien Aperghis-Tramoni, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Bot::MetaSyntactic
