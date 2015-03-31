package Bread::Board::Service::WithParameters;
use Moose::Role;
use MooseX::Params::Validate qw(validated_hash);

use Try::Tiny;
use Bread::Board::Types;

with 'Bread::Board::Service';

has 'parameters' => (
    traits    => [ 'Hash', 'Copy' ],
    is        => 'ro',
    isa       => 'Bread::Board::Service::Parameters',
    lazy      => 1,
    coerce    => 1,
    builder   => '_build_parameters',
    handles   => {
        'has_parameters' => 'count'
    }
);

around 'get' => sub {
    my $next = shift;
    my $self = shift;
    my @args = @_;
    my %params = $self->check_parameters(@args);
    my @parameter_keys_to_remove = keys %params;
    $self->params({ %{ $self->params }, %params });

    try {
        $self->$next(@args);
    }
    catch {
        die $_;
    }
    finally {
        $self->_clear_param( $_ ) foreach @parameter_keys_to_remove;
    };
};

sub _build_parameters { +{} }

sub check_parameters {
    my $self = shift;
    return validated_hash(\@_, (
        %{ $self->parameters },
        # NOTE:
        # cache the parameters in a per-service
        # basis, this should be more than adequate
        # since each service can only have one set
        # of parameters at a time. If this does end
        # up breaking then we can give it a better
        # key at that point.
        # - SL
        (MX_PARAMS_VALIDATE_CACHE_KEY => Scalar::Util::refaddr($self))
    )) if $self->has_parameters;
    return ();
}

sub has_required_parameters {
    my $self = shift;
    scalar grep { ! $_->{optional} } values %{ $self->parameters };
}

sub has_parameter_defaults {
    my $self = shift;
    scalar grep { $_->{default} } values %{ $self->parameters };
}

no Moose::Role; 1;

__END__

=pod

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item B<get>

=item B<parameters>

=item B<has_parameters>

=item B<has_parameter_defaults>

=item B<has_required_parameters>

=item B<check_parameters>

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=cut
