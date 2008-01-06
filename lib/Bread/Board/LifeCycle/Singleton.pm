package Bread::Board::LifeCycle::Singleton;
use Moose::Role;

with 'Bread::Board::LifeCycle';

has 'instance' => (
    is        => 'rw', 
    isa       => 'Any',
    predicate => 'has_instance',
    clearer   => 'flush_instance'
);

around 'get' => sub {
    my $next = shift;
    my $self = shift;
    return $self->instance if $self->has_instance;
    $self->instance($self->$next(@_));
};

1;

__END__

=pod

=head1 NAME

Bread::Board::

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item B<>

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Stevan Little E<lt>stevan@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2007-2008 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut