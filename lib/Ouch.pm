use strict;
use warnings;
package Ouch;
use Carp qw(longmess shortmess);
use parent 'Exporter';
use overload bool => sub {1}, q{""} => 'scalar', fallback => 1;

our @EXPORT = qw(ouch kiss);

sub new {
  my ($class, $code, $message, $data) = @_;
  bless {code => $code, message => $message, data => $data, shortmess => shortmess($message), trace => longmess($message) }, $class;
}

sub ouch {
  my ($code, $message, $data) = @_;
  my $self = __PACKAGE__->new($code, $message, $data);
  die $self;
}

sub kiss {
  my ($code, $e) = @_;
  $e ||= $@;
  if (ref $e eq 'Ouch' && $e->code == $code) {
    return 1;
  }
  return 0;
}

sub scalar {
  my $self = shift;
  return $self->{shortmess};
}

sub trace {
  my $self = shift;
  return $self->{trace};
}

sub hashref {
  my $self = shift;
  return {
    code    => $self->{code},
    message => $self->{message},
    data    => $self->{data},
  };
}

sub code {
  my $self = shift;
  return $self->{code};
}

sub message {
  my $self = shift;
  return $self->{message};
}

sub data {
  my $self = shift;
  return $self->{data};
}

=head1 NAME

Ouch - Exceptions that don't hurt.

=head1 SYNOPSIS

 use Ouch;

 eval { ouch 404, 'File not found.'; };

 if (kiss 404) {
   check_elsewhere();
 }

 say $@;           # These two lines do the
 say $@->message;  # same thing.

=head1 DESCRIPTION

Ouch provides a class for exception handling that doesn't require a lot of boilerplate, nor any up front definition. If L<Exception::Class>
is working for you, great! But if you want something that is faster, easier to use, requires less typing, and has no prereqs, but still gives 
you much of that same functionality, then Ouch is for you.

=head2 Why another exception handling module?

It really comes down to L<Carp> isn't enough for me, and L<Exception::Class> does what I want but makes me type way too much. Also, I tend to work on a lot of protocol-based systems that use error codes (HTTP, FTP, SMTP, JSON-RPC) rather than error classes, so that feels more natural to me. Consider the difference between these:

B<Ouch>

 use Ouch;
 ouch 404, 'File not found.', 'file';

B<Exception::Class>

 use Exception::Class (
    'FileNotFound' => {
        fields  => [ 'code', 'field' ],
    },
 );
 FileNotFound->throw( error => 'File not found.', code => 404, field => 'file' );

And if you want to catch the exception you're looking at:

B<Ouch>

 if (kiss 404) {
   # do something
 }

B<Exception::Class>

 my $e;
 if ($e = Exception::Class->caught('FileNotFound')) {
   # do something
 }

Those differences may not seem like a lot, but over any substantial program with lots of exceptions it can become a big deal. 

=head2 Usage

Most of the time, all you need to do is:

 ouch $code, $message, $data;
 ouch -32700, 'Parse error.', $request; # JSON-RPC 2.0 error
 ouch 441, 'You need to specify an email address.', 'email'; # form processing error

You can also go long form if you prefer:

 die Ouch->new($code, $message, $data);

=head2 Interface

=head3 ouch

Some nice sugar instead of using the object oriented interface.

 ouch 2121, 'Did not do the big thing.';

=over

=item code

An error code. An integer representing error type. Try to stick to codes used in whatever domain you happen to be working in. HTTP Status codes. JSON-RPC error codes, etc.

=item message

A human readable error message.

=item data

Optional. Anything you want to attach to the exception to help a developer catching it decide what to do. For example, if you're doing form processing, you might want this to be the name of the field that caused the exception.

=back

=head3 kiss

Some nice sugar to trap an Ouch.

 if (kiss $code) {
    # make it go
 }

=over

=item code

The code you're looking for.

=item exception

Optional. If you like you can pass the exception into C<kiss>. If not, it will just use whatever is in C<$@>. You might want to do this if you've saved the exception before running another C<eval>, for example.

=back

=head3 new

Constructor for the object-oriented interface. Takes the same parameters as C<ouch>.

 Ouch->new($code, $message, $data);

=head3 scalar

Returns the scalar form of the error message:

 Crap! at /Some/File.pm line 43.

Just as if you had done:

 die 'Crap!';

Rather than:

 ouch $code, 'Crap!'; 

=head3 trace

Call this if you want the full stack trace that lead up to the ouch.

=head3 hashref

Returns a formatted hash reference of the exception, which can be useful for handing off to a serializer like L<JSON>.

 {
   code     => $code,
   message  => $message,
   data     => $data,
 }

=head3 code

Returns the C<code> passed into the constructor.

=head3 message

Returns the C<messsage> passed into the constructor.

=head3 data

Returns the C<data> passed into the constructor.

=head1 SUPPORT

=over

=item Repository

L<http://github.com/rizen/Ouch>

=item Bug Reports

L<http://github.com/rizen/Ouch/issues>

=back


=head1 SEE ALSO

If you're looking for something lighter, check out L<Carp> that ships with Perl. Or if you're looking for something heavier check out L<Exception::Class>.

=head1 AUTHOR

JT Smith <jt_at_plainblack_dot_com>

=head1 LEGAL

Ouch is Copyright 2011 Plain Black Corporation (L<http://www.plainblack.com>) and is licensed under the same terms as Perl itself.

=cut

1;
