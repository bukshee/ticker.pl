# ticker.pl

> Real-time stock tickers from the command-line.

`ticker.pl` is a simple perl script using the Yahoo Finance API as a data source. It displayes current ticker prices in a colored output. It is able to display pre-market prices (denoted with `*`), too.

![ticker.pl](https://raw.githubusercontent.com/bukshee/ticker.pl/master/ticker.pl.png)

The script is a rewrite of [ticker.sh](https://github.com/pstadler/ticker.sh) in perl. It does not have any external dependencies and uses perl only.

The script prints the time and timezone of the data displayed. The time displayed comes from the last ticker.

## Install

Save the `ticker.pl` file into your `bin` directory or any directory reachable from `$PATH`. `chmod +x` to make it run without perl in front.

## Usage

```sh
# show default tickers that comes from the script
ticker.pl

# show your list
ticker.pl GOOGL F GC=F GOLD
```

You can create an alias with your favorite list to reduce typing.

## License

GPL-3

## Liability

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

