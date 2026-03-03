CXX = clang++
SRC_DIR = src
SRCS = $(shell find $(SRC_DIR) -name "*.cpp")

# Base object directories
BUILD_DIR = build
RELEASE_OBJDIR = $(BUILD_DIR)/release

CXXFLAGS_RELEASE = 	-I. \
					-std=c++23 \
					-O3 \
					-march=native -ffast-math -Rpass=loop-vectorize -Rpass-missed=loop-vectorize \
					-funroll-loops -ffp-contract=fast \
					-DNDEBUG \
					-MMD -MP \
					-c

# Map sources to object files
RELEASE_OBJS = $(patsubst $(SRC_DIR)/%.cpp,$(RELEASE_OBJDIR)/%.o,$(SRCS))

# ========================
# Targets
# ========================

# Default release build

release: $(RELEASE_OBJS)
	clang++ $(RELEASE_OBJS) -o main_release.out

# ========================
# Pattern rules for objects
# ========================

# Release objects
$(RELEASE_OBJDIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS_RELEASE) $< -o $@

# ========================
# Clean
# ========================
.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) main_release.out

# Include auto-generated dependency files
-include $(RELEASE_OBJS:.o=.d)
