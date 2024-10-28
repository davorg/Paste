package Paste;
use Dancer2;
use Dancer2::Plugin::DBIC;
use Try::Tiny;
use Paste::Schema;

our $VERSION = '0.1';

# Hook to set up the database connection before each request
hook before => sub {
  my $schema = Paste::Schema->connect("dbi:SQLite:paste.db")
    or die "Couldn't open database";

  var rs => $schema->resultset('Paste');
};

# Route to display the paste form
get '/' => sub {
  my $flash = session('flash');
  if ($flash) {
    session->delete('flash');
  }
  template 'request.tt', {
    header => 'perlpaste - a pastebin in perl',
    text   => 'the text',
    flash  => $flash,
  };
};

# Route to handle paste submission
post '/paste' => sub {
  my $title = body_parameters->get('title');
  my $paste = body_parameters->get('paste');

  # Input validation
  unless ($title && $paste) {
    status 400;
    return "Title and paste content are required.";
  }

  my $paste_db;
  try {
    $paste_db = vars->{rs}->create({
      title => $title,
      paste => $paste,
    });
  } catch {
    status 500;
    return "Failed to save paste.";
  };

  my $key = $paste_db->pastekey;
  my $link = request->scheme . '://' . request->host . "/$key";

  template 'paste.tt', {
    title => $title,
    paste => $paste,
    key   => $key,
    link  => $link,
  };
};

# Route to display a specific paste
get '/:id[Int]' => sub {
  my $id = route_parameters->get('id');

  my $data = vars->{rs}->find({ pastekey => $id });

  unless ($data) {
    session flash => "Paste $id not found.";
    return redirect '/';
  }

  template 'paste.tt', {
    title => $data->title,
    paste => $data->paste,
    key   => $data->pastekey,
    link  => request->uri_for(request->request_uri),
  };
};

get qr[(.+)] => sub {
  my ($id) = splat;
  session flash => "Invalid paste key: $id";
  redirect '/';
};

true;
