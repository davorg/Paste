package Paste;
use Dancer2;

our $VERSION = '0.1';

use DBI;

hook before => sub {
  var dbh => DBI->connect("dbi:SQLite:paste.db") || die "couldn't open";
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
  vars->{dbh}->do(
    'insert into pastes (title, paste) values (?, ?)', undef, $title, $paste
  );
  my $key = vars->{dbh}->selectall_arrayref(
    'select pastekey from pastes where paste = ?', undef, $paste
  );
  my $link = request->scheme . '://' . request->host . "/pastes/$key->[0][0]";
  template 'paste.tt', {
    'title' => $title,
    'paste' => $paste,
    'key'   => $key->[0][0],
    'link'  => $link,
  };
};

get '/pastes/:id' => sub {
  my $id = route_parameters->get('id');
  my $data = vars->{dbh}->selectall_arrayref(
    'select title, paste from pastes where pastekey = ?', undef, $id
  );

  my ($title, $paste) = @{ $data->[0] };

  template 'paste.tt', {
    'title' => $title,
    'paste' => $paste,
    'key'   => $id,
    'link'  => request->uri_for(request->request_uri),
  };
};

true;
