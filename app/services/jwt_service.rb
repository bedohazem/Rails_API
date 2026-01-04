class JwtService
  SECRET = ENV.fetch("JWT_SECRET") { "dev_secret_change_me" }

  def self.encode(payload, exp: 24.hours.from_now)
    payload = payload.merge({ exp: exp.to_i })
    JWT.encode(payload, SECRET, "HS256")
  end

  def self.decode(token)
    body, = JWT.decode(token, SECRET, true, { algorithm: "HS256" })
    body
  end
end
