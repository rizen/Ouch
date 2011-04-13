use strict;
use warnings;
package Ouch;
use parent 'Exporter';
use overload q{""} => 'message', fallback => 1;

our @EXPORT = qw(ouch);

sub new {
  my ($class, $code, $message, $data) = @_;
  bless [$code, $message, $data], $class;
}

sub ouch {
  my ($code, $message, $data) = @_;
  my $self = __PACKAGE__->new($code, $message, $data);
  die $self;
}

sub array {
    my $self = shift;
    return @{$self};
}

sub hashref {
  my $self = shift;
  return {
    code    => $self->[0],
    message => $self->[1],
    data    => $self->[2],
  };
}

sub code {
  my $self = shift;
  return $self->[0];
}

sub message {
  my $self = shift;
  return $self->[1];
}

sub data {
  my $self = shift;
  return $self->[2];
}

=head1 NAME

Ouch - Exceptions that don't hurt.

=cut

1;
