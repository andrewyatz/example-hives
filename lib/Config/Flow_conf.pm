package Config::Flow_conf;

=head1 LICENSE
 
Copyright [1999-2014] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
 
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
 
     http://www.apache.org/licenses/LICENSE-2.0
 
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
 
=cut

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
