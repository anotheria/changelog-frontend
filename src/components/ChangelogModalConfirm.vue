<template>
  <teleport to="body">
    <div class="modal-container">
      <div class="modal modal--center">
        <div class="modal__backdrop" @click="closeModal"></div>
        <div class="modal__content">
          <div class="modal__body">
            <div class="modal__title">Confirm</div>
            <div class="modal__text">Do you want delete this item?</div>
          </div>
          <div class="modal__footer">
            <div class="modal__footer-btns">
              <button class="modal__footer-btn" @click="$emit('confirm')">
                OK
              </button>
              <button class="modal__footer-btn" @click="closeModal">
                Cancel
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </teleport>
</template>

<script>
export default {
  emits: {
    "close-modal": null,
    "confirm": null
  },

  props: {},

  methods: {
    closeModal() {
      this.$emit("close-modal", false);
    },
  },
};
</script>

<style lang="scss" scoped></style>
