use strict;
use warnings;

use Test::More tests => 15;

use_ok( 'URI::Template' );

# fatal - no template provided
{
    eval { URI::Template->new; };
    ok( $@ );
}

{
    my $text     = 'http://foo.com/{bar}/{baz}?q=%7B';
    my $template = URI::Template->new( $text );
    isa_ok( $template, 'URI::Template' );
    is_deeply( [ sort $template->variables ], [ 'bar', 'baz' ], 'variables()' );
    is( "$template", $text, 'stringify' );

    {
        my $result = $template->process( bar => 'x', baz => 'y' );
        is( $result, 'http://foo.com/x/y?q=%7B', 'process()' );
        isa_ok( $result, 'URI', 'return value from process() isa URI' );
    }
    {
        my $result = $template->process_to_string( bar => 'x', baz => 'y' );
        is( $result, 'http://foo.com/x/y?q=%7B', 'process_to_string()' );
        ok( !ref $result, 'result is not a ref' );
    }
}

{
    my $template = URI::Template->new( 'http://foo.com/{z(}/' );
    my $result = $template->process( 'z(' => 'x' );
    is( $result, 'http://foo.com/x/', 'potential regex issue escaped' );
}

{
    my $template = URI::Template->new( 'http://foo.com/{z}/' );
    {
        my $result = $template->process( 'z' => '{x}' );
        is( $result, 'http://foo.com/%7Bx%7D/', 'values are uri escaped' );
    }
    {
        my $result = $template->process();
        is( $result, 'http://foo.com//', 'no value sent' );
    }
    {
        my $result = $template->process( 'y' => '1' );
        is( $result, 'http://foo.com//', 'no valid keys used' );
    }
}

{
    my $template = URI::Template->new( 'http://foo.com/{z}/{z}/' );
    is_deeply( [ sort $template->variables ], [ 'z' ], 'no duplicates in variables()' );
    my $result = $template->process( 'z' => 'x' );
    is( $result, 'http://foo.com/x/x/', 'multiple replaces' );
}

