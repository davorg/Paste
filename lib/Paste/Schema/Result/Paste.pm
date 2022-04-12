use utf8;
package Paste::Schema::Result::Paste;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Paste::Schema::Result::Paste

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<pastes>

=cut

__PACKAGE__->table("pastes");

=head1 ACCESSORS

=head2 pastekey

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 title

  data_type: 'text'
  is_nullable: 1

=head2 paste

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "pastekey",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "title",
  { data_type => "text", is_nullable => 1 },
  "paste",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</pastekey>

=back

=cut

__PACKAGE__->set_primary_key("pastekey");


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2022-04-12 20:13:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qkVsVU8IDu1ziK4ayCUO9Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
