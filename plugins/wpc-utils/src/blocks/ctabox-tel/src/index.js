import './style.css';
const { registerBlockType } = wp.blocks;
const { InspectorControls, RichText } = wp.editor;
const { TextControl } = wp.components;

registerBlockType( 'wpc-utils/ctabox-tel', {
    title: 'CTA Tel-Button',
    icon: 'phone',
    category: 'wpc-category',
    attributes: {
        tel: {
            type: 'string',
            source: 'text',
            selector: 'em',
            default: '0120-123-456'
        },
        openText: {
            type: 'string',
            source: 'text',
            selector: 'span',
            default: '24時間無料受付中'
        },
        buttonText: {
            type: 'string',
            source: 'text',
            selector: 'button',
            default: '今すぐ電話相談する'
        }
    },
    edit: ( props ) => {
        const { attributes: { tel, openText, buttonText }, setAttributes, className } = props;
        const noteTextStyle = {
            color: '#aaa'
        }

        return (
            <>
                <InspectorControls>
                    <TextControl
                        label='電話番号'
                        value={ tel }
                        onChange= { ( tel ) => setAttributes( { tel } ) }
                        placeholder='ex. 0120-123-456'
                    />
                </InspectorControls>
                <div className={ className }>
                    <p>
                        <em>{ tel }</em>
                        <RichText
                            value={ openText }
                            onChange= { ( openText ) => setAttributes( { openText } ) }
                            tagName="span"
                        />
                    </p>
                    <RichText
                        value={ buttonText }
                        onChange= { ( buttonText ) => setAttributes( { buttonText } ) }
                        tagName="button"
                        type="button"
                    />
                    <p role="note" style={ noteTextStyle }>[mobileのみ表示]</p>
                </div>
            </>
        )
    },
    save: ( props ) => {
        const { attributes: { tel, openText, buttonText }, setAttributes, className } = props;
        const tel_link = tel ? "tel:" + tel : '';
        return (
            <div className={ className }>
                <a href={ tel_link }>
                    <p>
                        <em>{ tel }</em>
                        <RichText.Content value={ openText } tagName="span" />
                    </p>
                    <RichText.Content value={ buttonText } tagName="button" />
                </a>
            </div>
        )
    },
} );
