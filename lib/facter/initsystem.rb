# Fact that looks at the OS family fact and based on the rules created, returns
# the primary init system for that platform.
#
# Important notes:
# 1. Yes it would be ideal to automatically resolve the init system rather than
#    using a hard list like below.
#
# 2. However some OSes might have multiples, eg Upstart + Init and it's not
#    always a case of the newer tech being the right one to use.
#
# 3. So here's a TODO: Change the following to still use specific OS matching
#    like configured, but replace the default with best-efforts auto detection.
#
# 4. I'll merge any decent PRs :-)
#


def initsystem_lookup

  case Facter.value(:osfamily)

  when 'RedHat'
    case Facter.value(:operatingsystem)

    when 'Amazon'
      # Whilst Amazon Linux is based off EL, it has quite different versioning
      # and has yet to make it to systemd.
      case Facter.value(:operatingsystemmajrelease)
      when '2014'
        'sysvinit'
      when '2015'
        'sysvinit'
      else
        'sysvinit' # default
      end

    else
      # Default RedHat generally means RHEL, CentOS or some other clone
      case Facter.value(:operatingsystemmajrelease)

      when '5'
        'sysvinit'
      when '6'
        'sysvinit' # RHEL 6 also has upstart, but the service tools don't handle it right. Stick to sysvinit here.
      when '7'
        'systemd'
      else
        'systemd' # future versions should all be systemd
      end
    end

  when 'Debian'
    case Facter.value(:operatingsystem)
    when 'Ubuntu'
      case Facter.value(:operatingsystemmajrelease)
      when '12.04'
        'upstart'
      when '14.04'
        'upstart'
      when '14.10'
        'upstart'
      when '15.04'
        'systemd'
      else
        'systemd' # All future Ubuntu versions should be systemd
      end

    when 'Debian'
      case Facter.value(:operatingsystemmajrelease)
      when '7'
        'sysvinit'
      when '8'
        'sysvinit'
      else
        'systemd' # All future Debian versions will be systemd
      end

    else
      # See comments below re defaults.
      'sysvinit'
    end

  when 'FreeBSD'
    case Facter.value(:operatingsystemmajrelease)
    when '9'
      'bsdinit'
    when '10'
      'bsdinit'
    else
      'bsdinit' # don't see them being likely to pickup systemd anytime soon
    end

  when 'Darwin'
    'launchd'

  else
    # Default for any unknown system is sysvinit since most distros inc systemd
    # using still support sysvinit scripts. In future, this default will change
    # to systemd, so if you're using sysvinit and you're not listed in the above
    # logic, please send in a pull request to avoid it suddenly changing.

    # TODO: Here is where we should write the automatic init system lookup
    # logic as mentioned in the header.
    'sysvinit'
  end
end


begin
  Facter.add('initsystem') { setcode { initsystem_lookup } }
rescue => e
  puts "An unexpected issue occured when trying to resolve the init system fact."
  raise e
end

# vim: ai ts=2 sts=2 et sw=2 ft=ruby
