package Config::Flow_conf;

use strict;
use warnings;

use base ('Bio::EnsEMBL::Hive::PipeConfig::HiveGeneric_conf');

sub default_options {
  my ($self) = @_;
  return {
    %{ $self->SUPER::default_options() },
    user => '',
    password => '',
    hive_driver => 'sqlite',
  };
}

sub pipeline_analyses {
  return [
    {
      -logic_name => 'Start',
      -module     => 'Flow::A',
      -input_ids  => [{ start => 1 }],
      -flow_into  => 'Flow',
    },
    {
      -logic_name => 'Flow',
      -module     => 'Flow::Flow',
      -flow_into  => { 1 => 'End', 2 => 'Alternative' },
    },
    {
      -logic_name => 'Alternative',
      -module     => 'Flow::A',
    },
    {
      -logic_name => 'End',
      -module     => 'Flow::A',
    },
  ];
}

1;
