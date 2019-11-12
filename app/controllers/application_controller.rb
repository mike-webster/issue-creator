class ApplicationController < ActionController::API
    def healthcheck
        render json: '{"status": "ok"}'
    end
end
