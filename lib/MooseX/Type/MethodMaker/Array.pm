package MooseX::Type::MethodMaker::Array;
use Moose;
extends 'Moose::Meta::Attribute';
use MooseX::Type::Util qw(register_type set_unless);

register_type("methodmaker_array");

sub new {
	my ($self, $name, %opts) = @_;
	set_unless(\%opts, is => 'rw');
	set_unless(\%opts, default => sub { [] });
	return $self->SUPER::new($name, %opts);
}

sub set_value {
	my ($self, $instance, @args) = @_;
	$self->SUPER::set_value($instance, ref($args[0]) eq 'ARRAY' && $#args == 0 ? $args[0] : \@args);
}

sub _inline_get_value {
	my ($self, $instance, @rest) = @_;
	my $name = $self->name;
	my $code = sprintf('return wantarray ? @{%s->{%s}} : %s->{%s}', $instance, $name, $instance, $name);
	return $code;
}

sub inline_get {
	my ($self, $instance, @rest) = @_;
	my $name = $self->name;
	my $code = sprintf('return wantarray ? @{%s->{%s}} : %s->{%s}', $instance, $name, $instance, $name);
	return $code;
}

# perl black magic explained:
# replace moose accessor setter (default is $_[0]->$name = $_[1])
# if number of arguments $#_ is 2 like for ($self, $value) and $value is an arrayref
# then assign the $value to attribute
# else make an arrayref from supplied arguments and assign it
sub _inline_set_value {
	my ($self, $instance, $value, @rest) = @_;
	if ($value eq '$_[1]') {
		$value = q| ref($_[1]) eq 'ARRAY' && $#_ == 1 ? $_[1] : [@_[1..$#_]]; |;
	}
	$self->SUPER::_inline_set_value($instance, $value, @rest);
}

# moose 1.09 compatibility
sub inline_set {
	my ($self, $instance, $value) = @_;
	if ($value eq '$_[1]') {
		$value = q| ref($_[1]) eq 'ARRAY' && $#_ == 1 ? $_[1] : [@_[1..$#_]]; |;
	}
	$self->SUPER::inline_set($instance, $value);
}

sub install_accessors {
	my ($self, $inline, @rest) = @_;

	my $class  = $self->associated_class;
	my $name = $self->{name};
	$class->add_method(sprintf("%s_reset", $name), sub { shift->$name([]) });
	$class->add_method(sprintf("%s_isset", $name), sub { scalar(@{ shift->$name }) });
	$class->add_method(sprintf("push_%s", $name), sub {
		my ($self, @args) = @_;
		push @{ $self->$name }, @args; 
	});
	$self->SUPER::install_accessors($self, $inline, @rest);
}

1;
