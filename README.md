# puppet-initfact

Provides a small fact to expose the primary/best init system available on this
system. This is extremely useful if writing modules that install init scripts,
since it tells you which one you need amongst all the fragementation and chaos
of the unix world.

Note that this isn't always as simple as it seems, for example some
distributions support multiple init systems but one is treated better than
others.

This fact uses the osfamily values to select a curated result that is known to
be the best option for that OS version. If it doesn't have an curated entry for
the specific OS/distro, it falls back to autodetection of the initsystem that
is being used.

# Usage

These are the same as any other fact, once adding the module to your Puppet
installation (eg via Puppetfile) you can simply read the fact within your
modules with something like:

    if ($::initsystem) {
      notify { "You are running the ${::initsystem} init system": }
    }

You can also check the output of the command on the CLI with:

    $ facter -p initsystem
    upstart


# Development

Contributions via the form of Pull Requests to add specific curated matches
or smarter auto-detection is always welcome.


# License

This module is licensed under the Apache License, Version 2.0 (the "License").
See the `LICENSE` or http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
