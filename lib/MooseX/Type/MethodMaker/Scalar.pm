package MooseX::Type::MethodMaker::Scalar;
use Moose;
extends 'Moose::Meta::Attribute';
use MooseX::Type::Util qw(register_type set_unless);

register_type("methodmaker_scalar");

sub new {
	my ($self, $name, %opts) = @_;
	set_unless(\%opts, clearer => sprintf("%s_reset", $name));
	set_unless(\%opts, predicate => sprintf("%s_isset", $name));
	set_unless(\%opts, is => 'rw');
	return $self->SUPER::new($name, %opts);
}

1;
