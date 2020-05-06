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
  my $title = param('title');
  my $paste = param('paste');
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
  my $id = params->{id};
  my $title = vars->{dbh}->selectall_arrayref(
    'select title from pastes where pastekey = ?', undef, $id
  );
  my $paste = vars->{dbh}->selectall_arrayref(
    'select paste from pastes where pastekey = ?', undef, $id
  );
  template 'paste.tt', {
    'title' => $title->[0][0],
    'paste' => $paste->[0][0],
    'key'   => $id,
    'link'  => '',
  };
};

true;
