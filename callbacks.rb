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
        logger.info "Setting HOST to #{fork_host}"
        @heroku.client.config_var.update(fork_name, {'HOST' => fork_host})
    end
  end

  private

  def heroku_fork
    @heroku_fork ||= Fourchette::Fork.new(@params)
  end

  def fork_name
    @fork_name ||= heroku_fork.fork_name
  end

  def fork_host
    @fork_url ||= "#{fork_name}.herokuapp.com"
  end
end
