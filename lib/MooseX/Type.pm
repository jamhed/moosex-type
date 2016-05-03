package MooseX::Type;
use Moose ();
use Moose::Exporter;
use Moose::Util;

use MooseX::Type::MethodMaker::Scalar;
use MooseX::Type::MethodMaker::Array;
use MooseX::Type::Scalar;

# filled with MooseX::Type::* packages
our %typemap;

Moose::Exporter->setup_import_methods(
	with_meta => [ 'has' ],
	also      => 'Moose',
);

# define type keyword in has parameters
sub has {
	my ($meta, $name, %options) = @_;

	my $context = $Moose::VERSION > 2.0 ? { Moose::Util::_caller_info } : Moose::Util::_caller_info; 

	$context->{context} = 'has declaration';
	$context->{type} = 'class';

	$options{definition_context} = $context;

	if (exists $options{type} && $options{type}) {
		my $metaclass = $typemap{$options{type}} ||
			die sprintf("Undefined type: %s, typemap: %s", $options{type}, join(" ", %typemap));
		$options{metaclass} = $metaclass;
		delete $options{type};
	}

	my $attrs = ( ref($name) eq 'ARRAY' ) ? $name : [ ($name) ];
	$meta->add_attribute($_, %options) for @$attrs;
}

1;
