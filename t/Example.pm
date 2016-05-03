package Example;

use MooseX::Type;

has [qw( table name alias )] => ( type => 'methodmaker_scalar' );
has rows => ( type => 'methodmaker_array' );

__PACKAGE__->meta->make_immutable;
