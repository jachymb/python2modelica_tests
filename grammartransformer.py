import re
from collections import OrderedDict

# Dictionary: {tokenstring: tokenname}
TOKENS = dict((l.split(" ") for l in open("tokens.txt").read().splitlines()))

# A simple bottom up parser for the rule production
# Scans the production bakwards, that makes dealing
# with the '*' and '+' operators much simpler.
# Note: Language of regexps forms a CFG.

class ProductionLexer:
    @staticmethod
    def _tokentype(tokenstr):
        if 'a' <= tokenstr[0] <= 'z': return 'a' # Non-terminal
        elif 'A' <= tokenstr[0] <= 'Z': return 'A' # Terminal
        else: return tokenstr[0]

    def __init__(self, production):
        production = production.strip()
        # Remove unnecessary parenthesis
        if production[0] == '(' and production[-1] == ')':
            production = production[1:-1]
        self.tokens = [
                (t, self._tokentype(t)) if self._tokentype(t) != "'" \
                    else (TOKENS[t[1:-1]], 'A')
                  for t in re.findall(
                      r"(\(|\)|\[|\]|\||'.*?'|\*|\+|[a-z_]+|[A-Z]+)",
                      production)]

    def nextToken(self):
        try:
            return self.tokens.pop()
        except IndexError:
            return None, None

    def lookup(self):
        try:
            return self.tokens[-1]
        except IndexError:
            return None, None

# A simple top-down parser for the regexp language
class ProductionParser:
    @staticmethod
    def _generatename(s):
        return s.strip().replace(" ","_").replace("|","_or_").lower()

    def __init__(self, production):
        self.lexer = ProductionLexer(production)
        self.addedrules = OrderedDict()
        self.count = 0

    def S(self):
        res = self.A()
        while self.lexer.lookup()[1] in ('|','A','a','*','+',']',')'):
            if self.lexer.lookup()[0] == '|':
                self.lexer.nextToken()
                res = self.A() + " | " + res
            else:
                res = self.A() + " " + res

        #res = self.A() + " " + res
        return re.sub(" +", " ", res).strip()

    def A(self):
        res = ""
        while self.lexer.lookup()[1] in ('a','A'):
            res = self.lexer.nextToken()[0] + " " + res
        lookuptoken, lookuptype = self.lexer.lookup()
        if lookuptype == ')':
            self.lexer.nextToken()
            inner = self.S()
            assert self.lexer.lookup()[1] == '('
            self.lexer.nextToken()
            name = self._generatename(inner)
            self.addedrules[name] = inner
            res = name + " " + res
        elif lookuptype == ']':
            self.lexer.nextToken()
            inner = self.S()
            assert self.lexer.lookup()[1] == '['
            self.lexer.nextToken()
            name = "optional__"+ self._generatename(inner)
            self.addedrules[name] = " | " + inner # optional expression
            res = name + " " + res
        elif lookuptype == '*':
            self.lexer.nextToken()
            expr = self.A()
            name = "zeroormore__" +self._generatename(expr)
            self.addedrules[name] = " | " + expr + " " + name
            res = name + " " + res
        elif lookuptype == "+":
            self.lexer.nextToken()
            expr = self.A()
            name = "oneormore__" + self._generatename(expr)
            self.addedrules[name] = expr + " " + name + " | " + expr
            res = name + " " + res
        return res

def printreduce(options, head):
    return "\n    | ".join([option + (' {printf("Parser: Reducing <%s> to <%s>\\n");}' % (option.strip(), head)) for option in options.split("|")])

if __name__ == "__main__":
    priority = [] # ["optional__test", "optional__testlist_comp", "optional__dictorsetmaker", "optional__yield_expr__or__testlist_comp"]

    oldgrammar = (l.split(":",1) for l in open("grammar.txt").read().splitlines())
    newgrammar = OrderedDict()

    for head, production in oldgrammar:
        parser = ProductionParser(production)
        s = parser.S()
        for k,v in (parser.addedrules.items()):
            if k not in newgrammar:
                newgrammar[k] = printreduce(v,k)
            else:
                assert printreduce(v,k) == newgrammar[k]
        newgrammar["\n"+head] = printreduce(s,head)+"\n"

    for head in priority:
        print(head +  ": " + newgrammar[head])
        del newgrammar[head]
    print()
    for head, production in newgrammar.items():
        print(head + ": " + production)
