package Flow::Flow;
use strict;
use warnings;
use base qw/Bio::EnsEMBL::Hive::Process/;

sub write_output {
  my ($self) = @_;
  $self->dataflow_output_id({ flow => 1}, 2);
}

1;
