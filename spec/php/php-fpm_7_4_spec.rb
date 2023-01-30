require "docker"
require "serverspec"

describe "php-fpm:7.4" do
  describe "metadata" do
    describe docker_image('php-fpm:7.4') do
      set :backend, :exec

      it { should exist }
      its(['Architecture']) { should eq 'amd64' }
      its(['Config.Cmd']) { should eq ['php-fpm'] }
    end
  end

  describe "container" do
    before(:all) do
      @image = Docker::Image.get('php-fpm:7.4')

      set :os, family: :ubuntu
      set :backend, :docker
      set :docker_image, @image.id
    end

    describe "Ensure dependencies are installed" do
      describe package('ca-certificates') do
          it { should be_installed }
        end

        describe package('curl') do
          it { should be_installed }
        end

        describe package('ghostscript') do
          it { should be_installed }
        end

        describe package('gifsicle') do
          it { should be_installed }
        end

        describe package('imagemagick') do
          it { should be_installed }
        end

        describe package('jpegoptim') do
          it { should be_installed }
        end

        describe package('openssl') do
          it { should be_installed }
        end

        describe package('optipng') do
          it { should be_installed }
        end

        describe package('pngquant') do
          it { should be_installed }
        end

        describe package('tar') do
          it { should be_installed }
        end

        describe package('unzip') do
          it { should be_installed }
        end

        describe package('webp') do
          it { should be_installed }
        end

        describe package('zip') do
          it { should be_installed }
        end

        describe package('php-apcu') do
          it { should be_installed }

          describe command('php -m') do
            its('stdout') { should match /^apcu$/ }
          end
        end

        describe package('php7.4-bcmath') do
          it { should be_installed }

          describe command('php -m') do
            its('stdout') { should match /^bcmath$/ }
          end
        end

        describe package('php7.4-common') do
          it { should be_installed }
        end

        describe package('php7.4-cli') do
          it { should be_installed }
        end

        describe package('php7.4-curl') do
          it { should be_installed }

          describe command('php -m') do
            its('stdout') { should match /^curl$/ }
          end
        end

        describe package('php7.4-fpm') do
          it { should be_installed }
        end

        describe package('php7.4-gd') do
          it { should be_installed }

          describe command('php -m') do
            its('stdout') { should match /^gd$/ }
          end
        end

        describe package('php-igbinary') do
          it { should be_installed }

          describe command('php -m') do
            its('stdout') { should match /^igbinary$/ }
          end
        end

        describe package('php-imagick') do
          it { should be_installed }

          describe command('php -m') do
            its('stdout') { should match /^imagick$/ }
          end
        end

        describe package('php7.4-intl') do
          it { should be_installed }

          describe command('php -m') do
            its('stdout') { should match /^intl$/ }
          end
        end

        describe package('php7.4-mbstring') do
          it { should be_installed }

          describe command('php -m') do
            its('stdout') { should match /^mbstring$/ }
          end
        end

        describe package('php7.4-mysql') do
          it { should be_installed }

          describe command('php -m') do
            its('stdout') { should match /^pdo_mysql$/ }
          end
        end

        describe package('php7.4-opcache') do
          it { should be_installed }

          describe command('php -m') do
            its('stdout') { should match /^Zend OPcache$/ }
          end
        end

        describe package('php7.4-readline') do
          it { should be_installed }

          describe command('php -m') do
            its('stdout') { should match /^readline$/ }
          end
        end

        describe package('php-redis') do
          it { should be_installed }

          describe command('php -m') do
            its('stdout') { should match /^redis$/ }
          end
        end

        describe package('php7.4-xml') do
          it { should be_installed }

          describe command('php -m') do
            its('stdout') { should match /^xml$/ }
          end
        end

        describe package('php-yaml') do
          it { should be_installed }

          describe command('php -m') do
            its('stdout') { match /^yaml$/ }
          end
        end

        describe package('php7.4-zip') do
          it { should be_installed }

          describe command('php -m') do
            its('stdout') { match /^zip$/ }
          end
        end
    end

    describe "Check php and php-fpm are runnable" do
      describe command('php -i') do
          its('exit_status') { should eq 0 }
        end

      describe command('php-fpm -tt') do
        its('exit_status') { should eq 0 }
      end
    end

    describe "Ensure no dev dependencies are installed" do
      describe package('php7.4-dev') do
        it { should_not be_installed }
      end

      describe package('php-pear') do
        it { should_not be_installed }
      end

      describe package('openssh-client') do
        it { should_not be_installed }
      end

      describe package('git') do
        it { should_not be_installed }
      end

      describe package('patch') do
        it { should_not be_installed }
      end

      describe command('php -m') do
        its('stdout') { should_not match /^xdebug$$/ }
      end

      describe command('which composer') do
        its('exit_status') { should eq 1 }
      end
    end

    describe "Ensure file and directories in container exists" do
      describe file('/usr/sbin/php-fpm') do
        it { should be_file }
        it { should be_mode 777 }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
      end

      describe file('/run/php') do
        it { should be_directory }
        it { should be_mode 755 }
        it { should be_owned_by 'www-data' }
        it { should be_grouped_into 'www-data' }
      end

      describe file('/var/log/xdebug.log') do
        it { should be_file }
        it { should be_mode 644 }
        it { should be_owned_by 'www-data' }
        it { should be_grouped_into 'www-data' }
      end

      describe file('/usr/local/bin/docker-php-entrypoint') do
        it { should be_file }
        it { should be_mode 755 }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
      end

      describe file('/etc/php/7.4/cli/conf.d/99-php.ini') do
        it { should be_file }
        it { should be_mode 644 }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
      end

      describe file('/etc/php/7.4/fpm/conf.d/99-php.ini') do
        it { should be_file }
        it { should be_mode 644 }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
      end
      # TODO: Add further relevant configuration files
    end

    describe "Ensure environment variables are set in container" do
      describe command('env') do
        its('stdout') { match /^PHP_VERSION=7.4/ }
        its('stdout') { match /^PHP_MEMORY_LIMIT=128m/ }
        its('stdout') { match /^PHP_MAX_EXECUTION_TIME=30/ }
        its('stdout') { match /^PHP_MAX_INPUT_VARS=1500/ }
        its('stdout') { match /^PHP_ASSERT=-1/ }
        its('stdout') { match /^PHP_XDEBUG_HOST=host.docker.internal/ }
        its('stdout') { match /^PHP_XDEBUG_MODE=off/ }
      end
    end
  end
end


