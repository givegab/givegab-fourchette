class Fourchette::PullRequest
  include SuckerPunch::Job

  # Can remove this once the following PR is accepted and the gem is updated
  # https://github.com/jipiboily/fourchette/pull/22
  def perform params
    unless skip_qa?(params)
      callbacks = Fourchette::Callbacks.new(params)
      fork = Fourchette::Fork.new(params)

      callbacks.before_all

      case params['action']
        when 'synchronize' # new push against the PR (updating code, basically)
          fork.update
        when 'closed'
          fork.delete
        when 'reopened'
          fork.create
        when 'opened'
          fork.create
      end

      callbacks.after_all
    end
  end

  private

  def skip_qa? params
    params.fetch('pull_request', {}).fetch('title', '').downcase.include?('[skip qa]')
  end

end
