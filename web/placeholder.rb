get '/placeholder' do
  logger.info('Serving the placeholder tarball!')
  send_file 'placeholder.tar.gz', :type => 'application/x-tgz'
end
