package MooseX::Type::Scalar;
use Moose;
extends 'Moose::Meta::Attribute';
use MooseX::Type::Util qw(register_type set_unless);

register_type("scalar");

sub new {
	my ($self, $name, %opts) = @_;
	my ($prefix, $naked) = ($name =~ /^(\_+)(.+)$/);
	unless ($naked) {
		$prefix = '';
		$naked = $name;
	}
	set_unless(\%opts, clearer => sprintf("%sclear_%s", $prefix, $naked));
	set_unless(\%opts, predicate => sprintf("%shas_%s", $prefix, $naked));
	set_unless(\%opts, is => 'rw');
	return $self->SUPER::new($name, %opts);
}

1;
