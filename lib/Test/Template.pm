package Test::Template;

use strict;
use warnings;

use parent q{Template};

use Hash::Merge::Simple;
use Path::Class qw(dir);
use HTML::Lint::Pluggable;
use Test::More;

sub validate {
    my ( $self, $output ) = @_;

    # Routine to validate HTML5 structure

    # If this looks like an HTML fragment, wrap it in minimal tags
    if ( $output !~ m{^<html[^>]*>}ims ) {

        $output = join(
            "\n",
            '<html><head><title>Title</title></head><body>',
            $output,
            '</body></html>'
        );
    }

    my $lint = HTML::Lint::Pluggable->new();

    $lint->load_plugins('HTML5');
    $lint->only_types(HTML::Lint::Error::STRUCTURE);
    $lint->parse($output);
    $lint->eof;

    my $message = 'output is valid HTML5';
    if ( $lint->errors ) {
        for my $error ( $lint->errors ) {
            warn $error->as_string, "\n";
        }
        fail($message);
    }
    else {
        pass($message);
    }

    return $output;

} ## end sub validate

sub _init {
    my ($self, $config) = @_;

    # Modify the _init() routine from Template:
    #
    #   * add an INPUT parameter so we can specify the template file or string
    #     to test.
    #
    #   * set the default template INCLUDE_PATH and other config options to be
    #     the same as used by our Catalyst view.
    #
    $self->{INPUT} = $config->{INPUT} or die "INPUT parameter is required";

    $config = Hash::Merge::Simple::merge(
        {
            INCLUDE_PATH => [
                dir( $ENV{'PWD'}, '/root/src' )->cleanup,
                dir( $ENV{'PWD'}, '/root/lib' )->cleanup,
            ],
            TRIM        => 1,
            PRE_CHOMP   => 1,
            POST_CHOMP  => 0,
            PRE_PROCESS => 'macro.tt2',
            TIMER       => 0,
        },
        $config
    );

    $self = $self->SUPER::_init($config);

    return $self;
}

sub process {
    my ( $self, $vars ) = @_;

    # Modify the process() routine from Template:
    #
    #    * make process() use the INPUT key for the template variable
    #    * die on errors rather than returning an error code
    #    * return the result of successful processing
    #    * always run the validate routine on processing a new template

    my $output = '';
    $self->SUPER::process( $self->{INPUT}, $vars, \$output )
      or die $self->error;

    return $self->validate($output);

} ## end sub process

1;
