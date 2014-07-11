class Fourchette::Fork
  include Fourchette::Logger

  def create_unless_exists
    unless @heroku.app_exists?(fork_name)
      @heroku.fork(ENV['FOURCHETTE_HEROKU_APP_TO_FORK'] ,fork_name)
      options = {
          source_blob: {
              url: '/placeholder'
          }
      }
      @heroku.client.build.create(fork_name, options)
      post_fork_url
    end
  end

end
