
describe('Quotes', function () {
    it('Can build and email a quote', function () {
        cy.visit("/")
        // create case file
        cy.contains('New Quote').click();
        cy.get('#quote_title').type("New Office Supplies");
        cy.get('#quote_email').type("office@supplies.com");
        cy.contains('Create').click();
        cy.contains('Quote was successfully created.')

        // This calls to the backend to prepare the application state
        cy.appFactories([
            ['create', 'item', 'duty5_trait', 'tax10_trait', { name: "Book", individual_cost: "0.5" }],
            ['create', 'item', 'duty5_trait', 'face_mask_trait'],
            ['create', 'first_aid_kit']
        ])

        cy.contains('Add Product').click();
        cy.get('#quote_product_item_id').select("Book");
        cy.get('#quote_product_amount').type("100");
        cy.contains('Add').click();
        cy.contains('product was successfully added.')

        cy.contains('100 Books for $57.5');
        cy.contains('For a Total of $57.5');

        cy.contains('Add Product').click();
        cy.get('#quote_product_item_id').select("Face mask");
        cy.get('#quote_product_amount').type("200");
        cy.contains('Add').click();
        cy.contains('product was successfully added.')

        cy.contains('100 Books for $57.5');
        cy.contains('200 Face masks for $210.0');
        cy.contains('For a Total of $267.5');

        cy.contains('Add Product').click();
        cy.get('#quote_product_item_id').select("First aid kit");
        cy.get('#quote_product_amount').type("10");
        cy.contains('Add').click();
        cy.contains('product was successfully added.')

        cy.contains('100 Books for $57.5');
        cy.contains('200 Face masks for $210.0');
        cy.contains('10 First aid kits for $100');
        cy.contains('For a Total of $367.5');
    })
});
