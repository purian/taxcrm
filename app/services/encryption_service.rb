require 'openssl'
require 'base64'

class EncryptionService
  def self.encrypt_password(password, public_key)
    rsa_key = OpenSSL::PKey::RSA.new(public_key)
    encrypted_password = rsa_key.public_encrypt(password, OpenSSL::PKey::RSA::PKCS1_PADDING)
    Base64.encode64(encrypted_password).strip
  end
end