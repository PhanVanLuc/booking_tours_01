const parent_1 = document.querySelector('#category_parent_id')
parent_1.addEventListener('change', (elm) => {
  getCategoriesbyParent(elm.target.value)
})

function getCategoriesbyParent(parent_id) {
  fetch(`/categories/by_parent?parent_id=${parent_id}`)
    .then(res => res.json())
    .then(data => {
      const { categories } = data;
      const parent_2 = document.querySelector('#parent_2');
      let options = ['<option value="">Chọn</option>'];
      categories.forEach(category => {
        const elm = `<option value="${category.id}">${category.category_name}</option>`
        options.push(elm)
      });
      parent_2.innerHTML = options.join();
    })
    .catch(err => console.error(err))
}