#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Template;

my $template = '';

my $tt = Test::Template->new({ INPUT => \$template, })
    or die "$Template::ERROR\n";

ok( $tt->process(), q{Processed template ok} );

subtest 'header' => sub {
    $template = q{[% header %]};

    my $content = $tt->process({ tank => { tank_name => 'Fooby-tank' } });
    like($content => qr{<h4>Fooby-tank - </h4>},
        q{tank name}
    );

    $content = $tt->process({ action_heading => 'gracNify' });
    like($content => qr{<h4>gracNify</h4>},
        q{action heading}
    );

    $content = $tt->process({
        tank           => { tank_name => 'Bobble-tank' },
        action_heading => 'splotz!'
    });
    like($content => qr{<h4>Bobble-tank - splotz!</h4>},
        q{tank name + action heading}
    );

    $template = q{[% header('<span>good html</span>') %]};

    ok($content = $tt->process(),
        q{processed xtra html}
    );
    like($content => qr{\Q<div class="col col-md-4 text-right">\E\s*
                        \Q<span>good html</span>\E\s*
                        </div>}msx,
        q{xtra html rendered}
    );
};

subtest 'href' => sub {
    # this is hardly worth it... just doing for the sake of completeness
    $template = q{[% href('/foo/bar/baz') %]};

    my $content = $tt->process();
    like($content => qr{href="/foo/bar/baz"},
        q{href snippet rendered}
    );
};

subtest 'paging' => sub {
    $template = q{[% paging %]};

    my $pager = {
        what  => 'dingleberries',
        path  => [ qw( foo bar baz ) ],
        first => 1,
        last  => 10,
        total_entries => 77,
    };

    my $content = $tt->process({ pager => $pager });

    like($content => qr{\QDisplaying 1 to 10 of 77&nbsp;dingleberries.\E}msx,
        q{paging report}
    );

    unlike($content => qr{<ul class="pagination pagination-sm">},
        q{paging buttons absent}
    );

    subtest 'pager at first page' => sub {
        $pager->{'last_page'}    = 5;
        $pager->{'first_page'}   = 1;
        $pager->{'current_page'} = 1;
        $pager->{'next_page'}    = 2;

        my $content = $tt->process({ pager => $pager });

        like($content => qr{<ul class="pagination pagination-sm">},
            q{paging buttons present}
        );

        like($content => qr{\Q<li class="disabled">\E\s*
                              <a\s*href="foo/bar/baz/1">&lt;&lt;first</a>}msx,
            q{first-page button disabled}
        );

        like($content => qr{\Q<li class="disabled">\E\s*
                              <a\s+href="foo/bar/baz/">&lt;previous</a>}msx,
            q{previous-page button disabled}
        );

        like($content => qr{<li\ class="disabled"><a\s+href="#">1</a></li>}msx,
            q{current-page button disabled}
        );

        like($content => qr{<li>\s*
                            <a\s+href="foo/bar/baz/2"\s*>next&gt;</a>\s*
                            </li>}msx,
            q{next-page button enabled}
        );

        like($content => qr{<li>\s*
                            <a\s+href="foo/bar/baz/5"\s*>last&gt;&gt;</a>\s*
                            </li>}msx,
            q{last-page button enabled}
        );
    };

    subtest 'pager at last page' => sub {
        $pager->{'last_page'}     = 5;
        $pager->{'first_page'}    = 1;
        $pager->{'current_page'}  = 5;
        $pager->{'next_page'}     = undef;
        $pager->{'previous_page'} = 4;

        my $content = $tt->process({ pager => $pager });

        like($content => qr{<ul class="pagination pagination-sm">},
            q{paging buttons present}
        );
        like($content => qr{<li>\s*
                            <a\s*href="foo/bar/baz/1">&lt;&lt;first</a>}msx,
            q{first-page button enabled}
        );

        like($content => qr{<li>\s*
                            <a\s+href="foo/bar/baz/4">&lt;previous</a>}msx,
            q{previous-page button enabled}
        );

        like($content => qr{<li\ class="disabled"><a\s+href="#">1</a></li>}msx,
            q{current-page button disabled}
        );

        like($content => qr{\Q<li class="disabled">\E\s*
                            <a\s+href="foo/bar/baz/"\s*>next&gt;</a>\s*
                            </li>}msx,
            q{next-page button disabled}
        );

        like($content => qr{\Q<li class="disabled">\E\s*
                            <a\s+href="foo/bar/baz/5"\s*>last&gt;&gt;</a>\s*
                            </li>}msx,
            q{last-page button disabled}
        );
    };
};

subtest 'form_errors' => sub {
    $template = q{[% form_errors %]};

    subtest 'no errors present' => sub {
        my $content = $tt->process();
        
        unlike($content => qr{<div class="row form_errors">},
            q{form errors}
        );
        unlike($content => qr{<div class="col text-success bg-success">},
            q{message}
        );
        unlike($content => qr{<div class="col text-danger bg-danger">},
            q{error}
        );
    };

    subtest 'errors present' => sub {
        my $content = $tt->process({
            message => 'This works',
            error   => 'This failed',
            form    => {
                get_errors => [
                    q{Form error #1},
                    q{Form error #2},
                ],
            },
        });

        like($content => qr{<div class="row form_errors">},
            q{form errors}
        );
        like($content => qr{<div class="col text-success bg-success">},
            q{message}
        );
        like($content => qr{<div class="col text-danger bg-danger">},
            q{error}
        );
    };
};

=pod

The following macros don't require tests:

=over

=item submit_btn

=item logout_btn

=item back_btn

=back

=cut

done_testing();

