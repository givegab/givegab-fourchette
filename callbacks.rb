class Fourchette::Callbacks
  include Fourchette::Logger

  def initialize params
    @params = params
    @heroku = Fourchette::Heroku.new
  end

  def before_all
    logger.info 'Before callbacks...'
  end

  def after_all
    logger.info 'After callbacks...'

    case @params['action']
      when 'closed'
        logger.info "PR was closed..."
      when 'opened', 'reopened'
        logger.info "PR was reopened..."
        logger.info "Setting BASE_URL to #{fork_url}"
        @heroku.client.config_var.update(fork_name, {'BASE_URL' => fork_url})
    end
  end

  private

  def heroku_fork
    @heroku_fork ||= Fourchette::Fork.new(@params)
  end

  def fork_name
    @fork_name ||= heroku_fork.fork_name
  end

  def fork_url
    @fork_url ||= "http://#{fork_name}.herokuapp.com"
  end
end
