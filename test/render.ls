require! {
  fs
  '../lib/oml'.render
  'chai'.expect
}

describe 'Render', ->

  describe 'primitives', (_) ->

    it 'should render "hello" as string', ->
      expect render 'hello' .to.be.equal 'hello'

    it 'should render "hello" as quoted string', ->
      expect render '"hello"' .to.be.equal 'hello'

    it 'should render "12.3" as number', ->
      expect render 12.3 .to.be.equal 12.3

    it 'should render "true" as boolean', ->
      expect render false .to.be.false

    it 'should render "[1,2,3]" as list', ->
      expect render "[1,2,3]" .to.be.deep.equal '123'

    it 'should render "- 1,2,3" as list', ->
      expect render "- 1,2,3" .to.be.deep.equal '123'

  describe 'self-closed', (_) ->

    xit 'should render as self-closed tag', ->
      expect render '!img' .to.be.equal '<img/>'

    it 'should render as self-closed tag', ->
      expect render 'img!:' .to.be.equal '<img/>'
    
    it 'should render "img!: nil" self-closed tag', ->
      expect render 'img!: nil' .to.be.equal '<img/>'

    it 'should render "img: nil" self-closed tag', ->
      expect render 'img: nil' .to.be.equal '<img/>'

  describe 'blocks', (_) ->

    describe 'in-line', (_) ->

      it 'should render "h1: hello"', -> 
        expect render 'h1: hello' .to.be.equal '<h1>hello</h1>'

      it 'should render "p: span: hello"', -> 
        expect render 'p: span: hello' .to.be.equal '<p><span>hello</span></p>'

      it 'should render "p.text: hello"', -> 
        expect render 'p.text: hello' .to.be.equal '<p class="text">hello</p>'
     
      it 'should render "p.text.another: hello"', -> 
        expect render 'p.text.another: hello' .to.be.equal '<p class="text another">hello</p>'

      it 'should render "p.text.another@id: hello"', -> 
        expect render 'p.text.another@id: hello' .to.be.equal '<p class="text another" id="id">hello</p>'

      it 'should render "p@id: hello"', -> 
        expect render 'p@id: hello' .to.be.equal '<p id="id">hello</p>'

    describe 'attributes', (_) ->

      it 'should render "a(href: /, title: Some link): link"', ->
        expect render 'a(href: "/", title: Some link): link' .to.be.equal '<a href="/" title="Some link">link</a>'        

      it 'should render "a(href: /, no-link): link"', ->
        expect render 'a(href: "/", no-link): link' .to.be.equal '<a href="/" no-link>link</a>'        

      it 'should render "a(href: /, no-link)" as only attributes tag', ->
        expect render 'a(href: "/", no-link)' .to.be.equal '<a href="/" no-link></a>'        

      it 'should render "a(style: \'z-index: 10px; diplay: block\')" as style attributes', ->
        expect render 'a(style: \'z-index: 10px; display: block\')' 
          .to.be.equal '<a style="z-index: 10px; display: block"></a>'        

    describe 'doctype', (_) ->

      it 'should render the default doctype', ->
        expect render 'doctype' .to.be.equal '<!DOCTYPE html>'

      it 'should render the xml doctype', ->
        expect render 'doctype xml' .to.be.equal '<?xml version="1.0" encoding="utf-8" ?>'

      it 'should render the xml doctype', ->
        expect render 'doctype strict' 
          .to.be.equal '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'

    describe 'nested', (_) ->

      it 'should render nested blocks properly', ->
        code = '''
          div:
            a.link@id: link
          end
        '''
        expect render code .to.be.equal '<div><a class="link" id="id">link</a></div>'
 
      it 'should render multiple nested with raw block', ->
        code = '''
          div:
            a.link@id: link
            script:>
              foo(bar)
            end
          end
        '''
        expect render code .to.be.equal '<div><a class="link" id="id">link</a><script>foo(bar)</script></div>'

      it 'should render multiple first-level nodes', ->
        code = '''
          script:>
            foo(bar)
          end
          div:
            a.link@id: link
          end
        '''
        expect render code .to.be.equal '<script>foo(bar)</script><div><a class="link" id="id">link</a></div>'

      it 'should render properly duplicated name tags', ->
        code = '''
          div:
            ul:
              li: Option 1
              li: a.link: Option 2
            end
          end
        '''
        expect render code .to.be.equal '<div><ul><li>Option 1</li><li><a class="link">Option 2</a></li></ul></div>'

      it 'should render mixed nested tags properly', ->
        code = '''
          .container:
            ul:
              li: Option 1
              li: a.link: Option 2
            end
            .footer:
              p.text: span: 'Hola' 
            end
          end
        ''' 
        expect render code .to.be.equal (
          '<div class="container"><ul><li>Option 1</li>' +
          '<li><a class="link">Option 2</a></li></ul>' +
          '<div class="footer"><p class="text"><span>Hola</span>' +
          '</p></div></div>'
        )

    describe 'html tags', (_) ->

      it 'should render with html tags', ->
        code = 'p: This is a plain <strong>text</strong>'
        expect render code .to.be.equal '<p>This is a plain <strong>text</strong></p>'

      it 'should render a block with html tags', ->
        code = '''
        div: 
          | <p>This is a plain <strong>text</strong></p>
        '''
        expect render code .to.be.equal '<div><p>This is a plain <strong>text</strong></p></div>'


    describe 'block types', (_) ->

      describe 'fold', (_) ->

        it 'should render a fold block', ->
          code = '''
          p:-
            hey! this is a sample
              text using
            oml and oli
          end
          '''
          expect render code .to.be.equal '<p>hey! this is a sample text using oml and oli</p>'

      describe 'unfold', (_) ->

        it 'should render an unfold block', ->
          code = '''
          p:=
            hey! this is a sample
              text using
            oml and oli
          end
          '''
          expect render code .to.be.equal '<p>hey! this is a sample\n  text using\noml and oli</p>'

      describe 'raw', (_) ->

        it 'should render a raw block', ->
          code = '''
          script:>
            if (foo) {
              bar(1 + 5)
            }
          end
          '''
          expect render code .to.be.equal '<script>if (foo) {\n  bar(1 + 5)\n}</script>'

      describe 'pipe', (_) ->

        it 'should render pipe expression with strings', ->
          code = '''
          div:
            | hello
            | text 
          '''
          expect render code .to.be.equal '<div>hello text</div>'

        it 'should render pipe expression with tags', ->
          code = '''
          div:
            | p: hello
            | span: text 
          '''
          expect render code .to.be.equal '<div><p>hello</p><span>text</span></div>'

    describe 'pretty render', (_) ->
      
      it 'should render as well-indented code', ->
        code = '''
          script:>
            foo(bar)
          end
          div:
            ul:
              li: Option 1
              li: a.link: Option 2
            end
          end
        '''
        expect render code, pretty: yes 
          .to.be.equal '''
            <script>foo(bar)</script>
            <div>
              <ul>
                <li>Option 1</li>
                <li>
                  <a class="link">Option 2</a>
                </li>
              </ul>
            </div>'''
        
    describe 'includes', (_) ->

      it 'should load and render an included file', ->
        code = 'include: test/fixtures/sample'
        expect render code .to.be.equal '<h1 class="title">Hello oml</h1>'

      it 'should load and render an included with extension', ->
        code = 'include: test/fixtures/sample.oli'
        expect render code .to.be.equal '<h1 class="title">Hello oml</h1>'

      describe 'interpolation', (_) ->

        it 'should include a interpolated content', ->
          code = '''
          div:
            h1: title
            include: test/fixtures/sample.oli
            footer: credits
          end
          '''
          expect render code .to.be.equal (
            '<div><h1>title</h1><h1 class="title">' +
            'Hello oml</h1><footer>credits</footer></div>'
          )

        it 'should include a interpolated content', ->
          code = '''
          html:
            include: test/fixtures/head
            body:
              h1: title
              p: Content
            end
          end
          '''
          expect render code .to.be.equal (
            '<html><head><title>Oml</title><script src="/src.js">' +
            '</script><script src="/src2.js">' +
            '</script></head><body><h1>title</h1><p>Content</p></body></html>'
          )

        it 'should throw an error if cannot include a file', ->
          code = '''
          html:
            include: non-existent.oli
          end
          '''
          expect (-> render code) .to.throw!

    describe 'requires', (_) ->

      it 'should load and render an included file', ->
        code = 'require: test/fixtures/sample'
        expect render code .to.be.equal '<h1 class="title">Hello oml</h1>'

      it 'should load and render an included with extension', ->
        code = 'require: test/fixtures/sample.oli'
        expect render code .to.be.equal '<h1 class="title">Hello oml</h1>'

      describe 'interpolation', (_) ->

        it 'should require a interpolated content', ->
          code = '''
          div:
            h1: title
            require: test/fixtures/sample.oli
            footer: credits
          end
          '''
          expect render code .to.be.equal (
            '<div><h1>title</h1><h1 class="title">' +
            'Hello oml</h1><footer>credits</footer></div>'
          )

    describe 'mixins', (_) ->

      it 'should define a mixin', ->
        code = '''
        mixin test:
          p: Hello
        end
        '''
        expect render code .to.be.equal ''

      it 'should throw an exception if a mixin do not exists', ->
        code = '+nonexists()'
        expect -> render code .to.throw.an Error

      it 'should call a mixin without arguments', ->
        code = '''
        mixin test:
          p: Hello
        end
        +test
        '''
        expect render code .to.be.equal '<p>Hello</p>'

      it 'should use a mixin with string arguments', ->
        code = '''
        mixin test(title, text):
          h1: $title
          p: $text
        end
        +test ('Hello Oml!', 'This is a mixin')
        '''
        expect render code .to.be.equal '<h1>Hello Oml!</h1><p>This is a mixin</p>'

      it 'should use a mixin with undefined arguments', ->
        code = '''
        mixin test(title, text):
          h1: $title
          p: $text
        end
        +test ('Hello Oml!')
        '''
        expect render code .to.be.equal '<h1>Hello Oml!</h1><p></p>'

      it 'should use a default argument value', ->
        code = '''
        mixin test(title, text: 'default'):
          h1: $title
          p: $text
        end
        +test ('Hello Oml!')
        '''
        expect render code .to.be.equal '<h1>Hello Oml!</h1><p>default</p>'

      it 'should use a number as default argument', ->
        code = '''
        mixin test(title, number: 123):
          h1: $title
          p: Number $number
        end
        +test ('Hello Oml!')
        '''
        expect render code .to.be.equal '<h1>Hello Oml!</h1><p>Number 123</p>'

      it 'should not replace a non-existent variable', ->
        code = '''
        mixin test:
          p: $nonexistent
        end
        +test
        '''
        expect render code .to.be.equal '<p>$nonexistent</p>'

      describe 'nested', (_) ->

        it 'should render a nested mixin', ->
          code = '''
          mixin title(name):
            h1: $name
          end
          div:
            +title ('Hello Oml!')
          end
          '''
          expect render code .to.be.equal '<div><h1>Hello Oml!</h1></div>'

  describe 'E2E', (_) ->
    result = null

    before -> 
      result := render (fs.read-file-sync 'test/fixtures/index.oli'), base-path: "#{__dirname}/fixtures" 

    it 'should have the proper doctype', ->
      expect result .to.match /<!DOCTYPE html>/
    
    it 'should have the body tag', ->
      expect result .to.match /<body>/

    it 'should have the head tag', ->
      expect result .to.match /<head>/

    it 'should have the expected title', ->
      expect result .to.match /<title>This is oml!/

    it 'should include the head file property with scripts tags', ->
      expect result .to.match /<script src=\"\/src.js\"><\/script>/

    it 'should have the script tag', ->
      expect result .to.match /<script>/
    
    it 'should have code in the script tag', ->
      expect result .to.match /if \(foo\) \{\n  bar\(2 \^ 2\)/
