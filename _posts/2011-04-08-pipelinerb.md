---
title: Pipeline.rb
layout: post
date: 2011-04-08 17:52:21
---
### Concept
Pipeline is a tool for applying image transformations to sequences of images, whether they be video files or directories. In particular, I wrote Pipeline to aid in processing animations, however it’s convenience is not limited to this scope.

The driving ideas behind Pipeline are:
* Firstly, the code describing image transformations ought to be separated from the code that applies them.
* Secondly, the language describing said transformations ought to offer a number of abstractions to facilitate complex, temporal image transformations.

In other words, Pipeline parses and applies a meta-language contained within so-called *plan files* across video files, directories of images, etc.:

<div class="caption">
<img src="/i/pipeline_flowchart.png" alt="Pipeline.rb process flow" />
<p>`Video out` is transparent in the above graphic, because I have yet to implement the feature.</p>
</div>

Pipeline takes a variable number of plan files which describe a set of image transformations. Next, Pipeline applies these transformations over either:
* a single image via `stdin`,
* a directory of images,
* or frames of a video.

Finally, the resulting processed images may be dumped to a new directory or saved or in-place, or—-in the case of `stdin`—-the singular image which gets processed outputs to `stdout`.

### Plan Files
The syntax for Pipeline.rb’s plan-files is inspired in part by the patching systems implemented in both [Max/MSP](http://cycling74.com/) and [Pure Data](http://puredata.info/). Moreover, the language is intended to be equally intuitive.

Plans allow for two types of commands:
* Variable assignments, and
* Function calls

Both variable assignments and function calls take arguments of the following types:
* Integer
* Float
* Predefined variables (i.e. `$1`, `$alpha`, etc.)
* External files (i.e., `%(masks/big_willie_style.png)`)
* String (this is tentative...)

For example, a plan to swap the green and blue channels of an image, while inverting the red channel, takes the following form:
{% highlight sh %}
splitRGB $1
invert $1
joinRGB $1 $3 $4
{% endhighlight %}

It is important to note that the numeric variables-—`$1`, `$2`, etc.-—are routinely overwritten by function calls within a plan. For example, had we wanted to apply ImageMagick’s edge filter with a strength of 8 to an image, we would have written:
{% highlight sh %}
splitRGB
$red = $1
edge $3 8
joinRGB $red $2 $1
{% endhighlight %}

In the above example, `splitRGB` saves the red channel of our input to `$1`. We must store this before we call `edge` on the blue channel (`$2`), since the output of `edge` will be stored in `$1`. Finally we rejoin the channels. Note that the green channel (`$2`) is unmodified.

#### Improved Syntax
Relying on the numbered variable system in the above examples grows cumbersome as the complexity of a plan file increases. Named variables circumvent this problem. Prior to this language feature, the following plan would have taken nearly 7 lines:
{% highlight sh %}
$r, $g, $b = split_rgb $1
$mask = center_fit %(images/masks/big_willie_style.png) $r
$r = multiply $mask $r
join_rgb $r $g $b
{% endhighlight %}

Significantly, in the above example, only the final line modifies a numbered variable; `join_rgb` overwrites `$1`.

#### Todo
I am considering adopting a Ruby-esque syntax, wherein any function call with an exclamation mark modifies its first argument in-place; i.e.,
{% highlight sh %}
multiply! $red $mask
{% endhighlight %}

would be the same as

{% highlight sh %}
$red = multiply $red $mask
{% endhighlight %}

### Implementation Details
#### Transforms
All plan file commands are stored in a `Hash`, with *keys* corresponding to function names and *values* corresponding to Lambda functions of type:
{% highlight haskell %}
State -> Args -> State
{% endhighlight %}

Where `State` is a `Hash` of `String/Object` pairs corresponding to variable names and values.

`Args` is an array of Lambda functions of type:
{% highlight haskell %}
State -> Int, Float, String, [String], Magick::Image, ...
{% endhighlight %}

Variable arguments lookup their variable name against the `State` passed to them and return the corresponding value. `Int`, `Float`, and `String` arguments ignore `State` and return themselves.

#### Processing
The aforementioned architecture makes Pipeline’s image processing as simple as:
1. Parse plan file(s) line-by-line,
	* looking-up each function name against the transforms `Hash` and
	* appending to a `List` of transforms
2. `inject` an ini­tial `State` pop­u­lated with the source image through the trans­forms
	* each transform will update the `State` passed to it accordingly
3. Return or save the final image contained in the `State`

This algorithm is evident in the following class definitions:
{% highlight ruby %}
class Transforms
  def initialize
    @transforms = []
  end
  def add(&transform)
    @transforms << transform
  end
  def to_proc
    # Here’s the work-horse: inject() is like Haskell’s `mapAccumL`
    lambda { |state| @transforms.inject(state) { |state, fn| fn.call(state) } }
  end
end

class Transform
  def initialize(name, args)
    @transform = $transforms[name] # instance looks itself up by name
    @args = args # `args` is list of Lambdas of type State -> Arg
  end
  def to_proc
    # The following returns an `update`-ed hash
    lambda { |state| state.update(@transform.call(state, @args)) }
  end
end
{% endhighlight %}
