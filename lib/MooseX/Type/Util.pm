package MooseX::Type::Util;
use Exporter 'import';
@EXPORT_OK = qw( register_type set_unless );
use strict;
use warnings;

sub register_type {
	my ($type) = @_;
	my ($handler) = caller;
	if (exists $MooseX::Type::typemap{$type}) {
		warn sprintf("Attempt to overwrite type: %s handled by: %s with %s", $type, $MooseX::Type::typemap{$type}, $handler);
	}
	$MooseX::Type::typemap{$type} = $handler;
}

sub set_unless {
	my ($hash, $option, $value) = @_;
	$hash->{$option} = $value unless exists $hash->{$option};
}

1;
