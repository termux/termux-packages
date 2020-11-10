#include "../src/memory/allocator.hpp"
#include "../src/memory/shared_ptr.hpp"

#include <iostream>
#include <memory>
#include <sstream>
#include <string>

#define ASSERT(cond) \
  if (!(cond)) { \
    std::cerr << "Assertion failed: " #cond " at " __FILE__ << ":" << __LINE__ << std::endl; \
    return false; \
  } \

class TestObj : public Sass::SharedObj {
 public:
  TestObj(bool *destroyed) : destroyed_(destroyed) {}
  ~TestObj() { *destroyed_ = true; }
  Sass::sass::string to_string() const {
    Sass::sass::ostream result;
    result << "refcount=" << refcount << " destroyed=" << *destroyed_;
    return result.str();
  }
 private:
  bool *destroyed_;
};

using SharedTestObj = Sass::SharedImpl<TestObj>;

bool TestOneSharedPtr() {
  bool destroyed = false;
  {
    SharedTestObj a = SASS_MEMORY_NEW(TestObj, &destroyed);
  }
  ASSERT(destroyed);
  return true;
}

bool TestTwoSharedPtrs() {
  bool destroyed = false;
  {
    SharedTestObj a = SASS_MEMORY_NEW(TestObj, &destroyed);
    {
      SharedTestObj b = a;
    }
    ASSERT(!destroyed);
  }
  ASSERT(destroyed);
  return true;
}

bool TestSelfAssignment() {
  bool destroyed = false;
  {
    SharedTestObj a = SASS_MEMORY_NEW(TestObj, &destroyed);
    a = a;
    ASSERT(!destroyed);
  }
  ASSERT(destroyed);
  return true;
}

bool TestPointerAssignment() {
  bool destroyed = false;
  std::unique_ptr<TestObj> ptr(new TestObj(&destroyed));
  {
    SharedTestObj a = ptr.get();
  }
  ASSERT(destroyed);
  ptr.release();
  return true;
}

bool TestOneSharedPtrDetach() {
  bool destroyed = false;
  std::unique_ptr<TestObj> ptr(new TestObj(&destroyed));
  {
    SharedTestObj a = ptr.get();
    a.detach();
  }
  ASSERT(!destroyed);
  return true;
}

bool TestTwoSharedPtrsDetach() {
  bool destroyed = false;
  std::unique_ptr<TestObj> ptr(new TestObj(&destroyed));
  {
    SharedTestObj a = ptr.get();
    {
      SharedTestObj b = a;
      b.detach();
    }
    ASSERT(!destroyed);
    a.detach();
  }
  ASSERT(!destroyed);
  return true;
}

bool TestSelfAssignDetach() {
  bool destroyed = false;
  std::unique_ptr<TestObj> ptr(new TestObj(&destroyed));
  {
    SharedTestObj a = ptr.get();
    a = a.detach();
    ASSERT(!destroyed);
  }
  ASSERT(destroyed);
  ptr.release();
  return true;
}

bool TestDetachedPtrIsNotDestroyedUntilAssignment() {
  bool destroyed = false;
  std::unique_ptr<TestObj> ptr(new TestObj(&destroyed));
  {
    SharedTestObj a = ptr.get();
    SharedTestObj b = a;
    ASSERT(a.detach() == ptr.get());
    ASSERT(!destroyed);
  }
  ASSERT(!destroyed);
  {
    SharedTestObj c = ptr.get();
    ASSERT(!destroyed);
  }
  ASSERT(destroyed);
  ptr.release();
  return true;
}

bool TestDetachNull() {
  SharedTestObj a;
  ASSERT(a.detach() == nullptr);
  return true;
}

class EmptyTestObj : public Sass::SharedObj {
  public:
    Sass::sass::string to_string() const { return ""; }
};

bool TestComparisonWithSharedPtr() {
  Sass::SharedImpl<EmptyTestObj> a = new EmptyTestObj();
  ASSERT(a == a);
  Sass::SharedImpl<EmptyTestObj> b = a;
  ASSERT(a == b);
  Sass::SharedImpl<EmptyTestObj> c = new EmptyTestObj();
  ASSERT(a != c);
  Sass::SharedImpl<EmptyTestObj> nullobj;
  ASSERT(a != nullobj);
  ASSERT(nullobj == nullobj);
  return true;
}

bool TestComparisonWithNullptr() {
  Sass::SharedImpl<EmptyTestObj> a = new EmptyTestObj();
  ASSERT(a != nullptr);
  Sass::SharedImpl<EmptyTestObj> nullobj;
  ASSERT(nullobj == nullptr);
  return true;
}

#define TEST(fn) \
  if (fn()) { \
    passed.push_back(#fn); \
  } else { \
    failed.push_back(#fn); \
    std::cerr << "Failed: " #fn << std::endl; \
  } \

int main(int argc, char **argv) {
  std::vector<std::string> passed;
  std::vector<std::string> failed;
  TEST(TestOneSharedPtr);
  TEST(TestTwoSharedPtrs);
  TEST(TestSelfAssignment);
  TEST(TestPointerAssignment);
  TEST(TestOneSharedPtrDetach);
  TEST(TestTwoSharedPtrsDetach);
  TEST(TestSelfAssignDetach);
  TEST(TestDetachedPtrIsNotDestroyedUntilAssignment);
  TEST(TestDetachNull);
  TEST(TestComparisonWithSharedPtr);
  TEST(TestComparisonWithNullptr);
  std::cerr << argv[0] << ": Passed: " << passed.size()
            << ", failed: " << failed.size()
            << "." << std::endl;
  return failed.size();
}
