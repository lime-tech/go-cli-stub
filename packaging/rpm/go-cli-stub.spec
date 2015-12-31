Summary: <<description>>
Name: go-cli-stub
Version: 1.0
Release: 1
License: <<license>>
Source0: %{name}-%{version}.tgz
Source1: %{name}.service
Source2: %{name}.tmpfiles.d.conf
Packager: <<author>>
BuildRequires: golang
%description
<<description>>
%prep
%setup
%build
export GOPATH="$(pwd)"
export PATH="$PATH:$(pwd)/bin"
export root='src/'%{name}
source "$root"/bootstrap
make %{name}
%post
%tmpfiles_create %{name}.conf
%systemd_post %{name}.service
chown -R %{name} %{_sysconfdir}/%{name}
chmod 700 %{_sysconfdir}/%{name}
chmod 600 %{_sysconfdir}/%{name}/*.toml
%pre
{
    if ! getent passwd %{name}
    then
        getent group %{name} || groupadd -r %{name}
        mkdir -p /var/lib/%{name}
        useradd -r -g %{name} -s /sbin/nologin -d /var/lib/%{name} -c "%{summary}" %{name}
        chown %{name}:%{name} /var/lib/%{name}
    fi
} > /dev/null
exit 0
%preun
%systemd_preun %{name}.service
%postun
%systemd_postun_with_restart %{name}.service
%clean
rm -rf $RPM_BUILD_ROOT
%install
install -m0755 -D            src/%{name}/%{name}       $RPM_BUILD_ROOT%{_bindir}/%{name}
install -m0600 -D            src/%{name}/config.toml   $RPM_BUILD_ROOT%{_sysconfdir}/%{name}/config.toml
install -m0644 -D -p         %{SOURCE1}                $RPM_BUILD_ROOT%{_unitdir}/%{name}.service
install -m0644 -D -p         %{SOURCE2}                $RPM_BUILD_ROOT%{_tmpfilesdir}/%{name}.conf
%files
%defattr(-,root,root,0755)
%doc src/%{name}/README.md
%config(noreplace) %{_sysconfdir}/%{name}/config.toml
%{_bindir}/%{name}
%{_tmpfilesdir}/%{name}.conf
%{_unitdir}/%{name}.service
