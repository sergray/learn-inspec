# include_controls 'ssl_certificate'

BASE_HOST = "sergray.me"
BLOG_HOST = "blog.sergray.me"

# Make sure network connectivity is OK
[BASE_HOST, BLOG_HOST].each do |hostname|
    [80, 443].each do |port|
        describe host(hostname, port: port, protocol: 'tcp') do
            it { should be_reachable }
            it { should be_resolvable }
        end
    end
    # Ensure SSL is enabled
    describe ssl(host: hostname, port: 443) do
        it { should be_enabled }
        its('protocols') { should_not eq 'ssl2' }
    end
    # Audit SSL certificate
    describe ssl_certificate(host: hostname, port: 443) do
        it { should exist }
        it { should be_trusted }
        its('ssl_error') { should eq nil }
        its('expiration_days') { should be >= 30 }
    end
end

# Ensure redirect from http://sergray.me to https://sergray.me
describe http("http://#{BASE_HOST}", ssl_verify: false) do
    its('status') { should eq 301 }
    its('headers.Location') { should match("https://#{BASE_HOST}") }
end

# Ensure redirect from https://sergray.me to https://blog.sergray.me
describe http("https://#{BASE_HOST}", ssl_verify: true) do
    its('status') { should eq 302 }
    its('headers.Location') { should match("https://#{BLOG_HOST}") }
end

# Ensure blog opens up
describe http("https://#{BLOG_HOST}", ssl_verify: true) do
    its('status') { should eq 200 }
end
