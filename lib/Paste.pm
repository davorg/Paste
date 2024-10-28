package Paste;
use Dancer2;
use Paste::Schema;

our $VERSION = '0.1';

use DBI;

hook before => sub {
  my $schema = Paste::Schema->connect("dbi:SQLite:paste.db")
    or die "couldn't open";

  var rs => $schema->resultset('Paste');
};

get '/' => sub {
  template 'request.tt', {
    'header' => 'perlpaste - a pastebin in perl',
    'text'   => 'the text',
  };
};

post '/paste' => sub {
  my $title = body_parameters->get('title');
  my $paste = body_parameters->get('paste');

  my $paste_db = vars->{rs}->create({
    title => $title,
    paste => $paste,
  });

  my $key = $paste_db->pastekey;

  my $link = request->scheme . '://' . request->host . "/pastes/$key";
  template 'paste.tt', {
    'title' => $title,
    'paste' => $paste,
    'key'   => $key,
    'link'  => $link,
  };
};

get '/:id[Int]' => sub {
  my $id = route_parameters->get('id');
  my $data = vars->{rs}->find({ pastekey => $id });;

  unless ($data) {
    status 404;
    return "Paste $id not found.";
  }

  template 'paste.tt', {
    'title' => $data->title,
    'paste' => $data->paste,
    'key'   => $data->pastekey,
    'link'  => request->uri_for(request->request_uri),
  };
};

true;
