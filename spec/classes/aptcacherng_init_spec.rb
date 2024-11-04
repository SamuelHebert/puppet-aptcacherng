require 'spec_helper'

# aptcacherng
describe 'aptcacherng', type: :class do
  describe 'On Debian' do
    let(:facts) { { osfamily: 'Debian' } }

    it { is_expected.to contain_class('aptcacherng::install') }
    it { is_expected.to contain_class('aptcacherng::config') }
    it { is_expected.to contain_class('aptcacherng::service') }
    it { is_expected.to contain_package('apt-cacher-ng') }
    it { is_expected.to contain_service('apt-cacher-ng') }
    it { is_expected.to contain_file('/etc/apt-cacher-ng/zz_debconf.conf').with_ensure('absent') }
    describe 'With default params' do
      ['/var/cache/apt-cacher-ng', '/var/log/apt-cacher-ng'].each do |d|
        it {
          is_expected.to contain_file(d).with(
            ensure: 'directory',
            owner: 'apt-cacher-ng',
            group: 'apt-cacher-ng',
            mode: '2755',
          )
        }
      end

      it {
        is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with(
          owner: 'root',
          group: 'root',
          mode: '0644',
        )
      }

      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^CacheDir: \/var\/cache\/apt-cacher-ng$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^LogDir: \/var\/log\/apt-cacher-ng$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^Port: 3142$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^ReportPage: acng-report.html$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^ExThreshold: 4$}) }
      it { is_expected.not_to contain_file('/etc/apt-cacher-ng/security.conf') }
    end # with default params

    describe 'With specific params' do
      ## Parameter set
      # a non-default common parameter set
      let :params_set do
        {
          cachedir: '/srv/apt-cacher-ng/cache',
          logdir: '/srv/apt-cacher-ng/logs',
          supportdir: '/srv/apt-cacher-ng/files',
          port: 6666,
          bindaddress: 'apt-cacher.mydomain.tld, 0.0.0.0',
          proxy: 'username:proxypassword@proxy.example.net:3128',
          remap_lines: [
            'Remap-debrep: file:deb_mirror',
          ],
          reportpage: 'report.html',
          socketpath: '/srv/apt-cacher-ng/socket',
          unbufferlogs: 1,
          verboselog: 1,
          foreground: '1',
          pidfile: '/srv/apt-cacher-ng/pid',
          offlinemode: '0',
          forcemanaged: '1',
          exthreshold: 4,
          exabortonproblems: '30',
          stupidfs: '1',
          forwardbtssoap: '0',
          dnscacheseconds: '7200',
          maxstandbyconthreads: '16',
          maxconthreads: '-1',
          vfilepattern: 'foo',
          pfilepattern: 'boo',
          wfilepattern: 'zoo',
          passthroughpattern: 'baz',
          debug: '3',
          exposeorigin: '1',
          logsubmittedorigin: '1',
          useragent: 'Yet, Another HTTP Client',
          recompbz2: '1',
          networktimeout: '120',
          dontcacherequested: 'linux-headers-i386',
          dontcacheresolved: 'ubuntumirror.local.net',
          dontcache: 'linux-headers-i386',
          dirperms: '00755',
          fileperms: '00644',
          localdirs: 'woo, hamm',
          precachefor: 'debrep',
          requestappendix: 'X-Tracking-Choice:, do-not-track',
          connectproto: 'v6, v4',
          keepextraversions: '1',
          usewrap: '1',
          freshindexmaxage: '42',
          allowuserports: '8080',
          redirmax: '10',
          vfileuserangeops: '0',
          auth_username: 'blah',
          auth_password: 'ChangeMe',
        }
      end

      let(:params) { params_set }

      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^CacheDir: #{params_set[:cachedir]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^LogDir: #{params_set[:logdir]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^SupportDir: #{params_set[:supportdir]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^Port: #{params_set[:port]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^BindAddress: #{params_set[:bindaddress]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^Proxy: #{params_set[:proxy]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^#{params_set[:remap_lines].join('|')}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^ReportPage: #{params_set[:reportpage]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^SocketPath: #{params_set[:socketpath]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^UnbufferLogs: #{params_set[:unbufferlogs]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^VerboseLog: #{params_set[:verboselog]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^ForeGround: #{params_set[:foreground]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^PidFile: #{params_set[:pidfile]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^OfflineMode: #{params_set[:offlinemode]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^ForceManaged: #{params_set[:forcemanaged]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^ExThreshold: #{params_set[:exthreshold]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^ExAbortOnProblems: #{params_set[:exabortonproblems]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^StupidFs: #{params_set[:stupidfs]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^ForwardBtsSoap: #{params_set[:forwardbtssoap]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^DnsCacheSeconds: #{params_set[:dnscacheseconds]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^MaxStandbyConThreads: #{params_set[:maxstandbyconthreads]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^MaxConThreads: #{params_set[:maxconthreads]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^VfilePattern: #{params_set[:vfilepattern]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^PfilePattern: #{params_set[:pfilepattern]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^WfilePattern: #{params_set[:wfilepattern]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^PassThroughPattern: #{params_set[:passthroughpattern]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^Debug: #{params_set[:debug]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^ExposeOrigin: #{params_set[:exposeorigin]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^LogSubmittedOrigin: #{params_set[:logsubmittedorigin]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^UserAgent: #{params_set[:useragent]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^RecompBz2: #{params_set[:recompbz2]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^NetworkTimeout: #{params_set[:networktimeout]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^DontCacheRequested: #{params_set[:dontcacherequested]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^DontCacheResolved: #{params_set[:dontcacheresolved]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^DontCache: #{params_set[:dontcache]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^DirPerms: #{params_set[:dirperms]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^FilePerms: #{params_set[:fileperms]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^LocalDirs: #{params_set[:localdirs]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^PrecacheFor: #{params_set[:precachefor]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^RequestAppendix: #{params_set[:requestappendix]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^ConnectProto: #{params_set[:connectproto]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^KeepExtraVersions: #{params_set[:keepextraversions]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^UseWrap: #{params_set[:usewrap]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^FreshIndexMaxAge: #{params_set[:freshindexmaxage]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^AllowUserPorts: #{params_set[:allowuserports]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^RedirMax: #{params_set[:redirmax]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/acng.conf').with_content(%r{^VfileUseRangeOps: #{params_set[:vfileuserangeops]}$}) }
      it { is_expected.to contain_file('/etc/apt-cacher-ng/security.conf').with_content(%r{^AdminAuth: #{params_set[:auth_username]}:#{params_set[:auth_password]}$}) }
    end
  end # Debian
end # aptcacherng
