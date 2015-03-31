package Bread::Board::LifeCycle::Prototype;
use Moose::Role;

with 'Bread::Board::LifeCycle';

no Moose::Role; 1;

__END__

=pod

=head1 DESCRIPTION

This L<lifecycle|Bread::Board::LifeCycle> role does nothing. It's
equivalent to the default behaviour of
L<services|Bread::Board::Service> of returning different instances on
each call to L<< C<get>|Bread::Board::Service/get >>.

This exists to allow you to be explicit in what kind of lifecycle you
want for a service, without having to special-case a name.

=cut
